module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Shared LUT for all operations
    reg [2:0] lut [0:15];
    
    // Initialize LUT contents
    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            // Bit 0: AND result (1 only when all bits are 1)
            lut[i][0] = (i == 15);
            // Bit 1: OR result (0 only when all bits are 0)
            lut[i][1] = (i != 0);
            // Bit 2: XOR result (parity of input bits)
            lut[i][2] = ^(i);
        end
    end

    // Output the pre-computed results
    assign out_and = lut[in][0];
    assign out_or  = lut[in][1];
    assign out_xor = lut[in][2];

endmodule