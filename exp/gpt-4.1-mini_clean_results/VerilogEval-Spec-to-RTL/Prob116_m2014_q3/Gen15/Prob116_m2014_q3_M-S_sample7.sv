module TopModule (
    input  [3:0] x,
    output       f
);

    // Use input x directly as address; map each 4-bit input to output f
    // Only minterms with output 1 from K-map are explicitly assigned;
    // others default to 0, including don't-cares.

    assign f = (x == 4'b0101)  // row=01 col=10 (1)
            || (x == 4'b1000)  // row=10 col=00 (1)
            || (x == 4'b1001)  // row=10 col=01 (1)
            || (x == 4'b1100)  // row=11 col=00 (1)
            || (x == 4'b1101); // row=11 col=01 (1)

endmodule