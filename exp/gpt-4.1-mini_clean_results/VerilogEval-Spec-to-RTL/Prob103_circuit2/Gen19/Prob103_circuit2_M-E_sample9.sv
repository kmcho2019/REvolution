module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire pair1_even;
    wire pair2_even;

    assign pair1_even = ~(a ^ b); // XNOR to check even parity in first pair
    assign pair2_even = ~(c ^ d); // XNOR to check even parity in second pair

    assign q = pair1_even & pair2_even; // overall even parity if both pairs have even parity

endmodule