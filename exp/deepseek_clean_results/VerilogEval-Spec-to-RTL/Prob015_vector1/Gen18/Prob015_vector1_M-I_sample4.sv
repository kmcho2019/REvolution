module TopModule (
    input  [15:0] in,          // 16-bit input word
    output [7:0]  out_hi,      // Upper byte (bits [15:8])
    output [7:0]  out_lo       // Lower byte (bits [7:0])
);

    // Explicit wire declarations (though not strictly necessary)
    wire [7:0] upper_byte;
    wire [7:0] lower_byte;

    // Byte splitting with clear comments
    assign upper_byte = in[15:8];  // MSB is left-most bit (big-endian)
    assign lower_byte = in[7:0];   // LSB is right-most bit

    // Drive outputs
    assign out_hi = upper_byte;
    assign out_lo = lower_byte;

endmodule