module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Fixed constant multiplier derived from q when a=1
    localparam [15:0] CONST = 16'h1232;

    // Combinational multiplier: q = a * CONST
    assign q = a * CONST;

endmodule