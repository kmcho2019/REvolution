// TopModule: Splits a 16-bit input into upper and lower 8-bit outputs
module TopModule (
    input  [15:0] in,       // 16-bit input word
    output [7:0]  out_hi,   // Upper byte [15:8]
    output [7:0]  out_lo    // Lower byte [7:0]
);

    // Continuous assignments for combinational logic
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];

endmodule