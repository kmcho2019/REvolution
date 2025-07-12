module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

// Lookup tables for AND, OR, and XOR gates
reg [1:0] and_lut [15:0];
reg [1:0] or_lut [15:0];
reg [1:0] xor_lut [15:0];

// Initialize LUTs based on gate truth tables
initial begin
    // AND gate LUT
    for (int i = 0; i < 16; i++) begin
        and_lut[i] = (i == 15) ? 1'b1 : 1'b0;
    end
    
    // OR gate LUT
    for (int i = 0; i < 16; i++) begin
        or_lut[i] = (i == 0) ? 1'b0 : 1'b1;
    end
    
    // XOR gate LUT
    for (int i = 0; i < 16; i++) begin
        xor_lut[i] = (i[0] ^ i[1] ^ i[2] ^ i[3]) ? 1'b1 : 1'b0;
    end
end

// Use LUTs to determine outputs
always @(*) begin
    out_and = and_lut[in];
    out_or = or_lut[in];
    out_xor = xor_lut[in];
end

endmodule