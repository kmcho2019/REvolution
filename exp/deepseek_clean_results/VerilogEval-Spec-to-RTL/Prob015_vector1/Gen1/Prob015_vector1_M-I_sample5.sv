module TopModule (
    input  [15:0] in,       // 16-bit input word
    output [7:0]  out_hi,   // Upper byte [15:8]
    output [7:0]  out_lo    // Lower byte [7:0]
);

    // Split input into upper and lower bytes
    assign out_hi = in[15:8];  // MSB byte
    assign out_lo = in[7:0];   // LSB byte

endmodule