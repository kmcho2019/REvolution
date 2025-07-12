module TopModule(
    input  wire [3:0] in,
    output wire       out_and,
    output wire       out_or,
    output wire       out_xor
);

    // LUT with 16 entries (4-bit input) and 3-bit output
    // Format: {out_and, out_or, out_xor}
    reg [2:0] lut [0:15];
    
    // Initialize LUT with precomputed values
    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            lut[i][0] = &i[3:0];  // AND
            lut[i][1] = |i[3:0];  // OR
            lut[i][2] = ^i[3:0];  // XOR
        end
    end

    // Output assignments
    assign {out_and, out_or, out_xor} = lut[in];

endmodule