# # Tutorial: Simulated Data
#
# In this tutorial we simulate a random patient population from a
# health clinic dealing with hypertension and type 2 diabetes. We
# assume the reader has read "Thinking in Combinators" and wishes to
# use `DataKnots` for this simulation.

using DataKnots

# ## Getting Started
#
# For this simulation, we don't have a data source. To create rows for
# a data set, we define the `OneTo` combinator that wraps Julia's
# `UnitRange`. Let's then create a list of 3 `patient` rows.

OneTo(N) = Lift(UnitRange, (1, N))
run(:patient => OneTo(3))

# Known data is boring in a simulation. Instead we need pseudorandom
# data. To make that data repeatable, let's fix the `seed`. We can then
# lift the `rand` function to a DataKnot combinator.

using Random: seed!, rand
seed!(1)
Rand(r) = Lift(rand, (r,));

# Suppose each patient is assigned a random 5-digit Medical Record
# Number ("MRN"). Let's define and test this concept.

RandMRN =
  :mrn => Rand(10000:99999)
run(RandMRN)

# To assign Sometimes it's useful to use categorical distributions.
# Let's define a random male/female sex distribution.

using Distributions
SexDist = Categorical([.492, .508])
run(Rand(SexDist))

# While this is nice, it makes it challenging to remember which is a
# male or a female. Julia has an enumerated type for this purpose and
# we can lift this as well.

@enum Sex male=1 female=2
RandSex =
  :sex => Lift(Sex, (Rand(SexDist),))
run(RandSex)

# With these primitives, we could start building our sample data set.
# Notice how each combinator can be defined/tested independently and
# then arranged to build a set of random patients.

RandPatient =
  :patient => Record(RandMRN, RandSex)
run(OneTo(Rand(3:5)) >> RandPatient)

#
# ## Function Composition via Combinators
#

