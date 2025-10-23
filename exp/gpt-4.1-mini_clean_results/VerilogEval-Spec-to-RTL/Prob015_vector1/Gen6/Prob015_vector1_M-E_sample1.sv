module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    wire [15:0] combined;

    // Assign combined to input vector
    assign combined = in;

    // Split combined into out_hi and out_lo
    assign out_lo = combined[7:0];
    assign out_hi = combined[15:8];

endmodule