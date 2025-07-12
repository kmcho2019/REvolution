module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Optimal fused implementation - direct byte splitting
    assign out_hi = in[15:8];  // Upper byte
    assign out_lo = in[7:0];   // Lower byte

endmodule