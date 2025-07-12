module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output wire [15:0] result,  // Quotient
    output wire [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Registered inputs (combinational "register")
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // We'll create 17 remainder signals (from initial 0 remainder up to after 16 bits processed)
    // Each remainder is 9 bits wide: 8 bits plus carry/borrow bit for comparison
    wire [8:0] rem [0:16];
    wire       quotient_bits [15:0];

    // Initial remainder is zero
    assign rem[0] = 9'd0;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : div_loop
            // Shift remainder left by 1 bit and append the current dividend bit
            wire [8:0] rem_shifted = {rem[i][7:0], a_reg[15 - i]};
            
            // Compare rem_shifted with divisor (zero-extend divisor to 9 bits)
            wire rem_ge_div = (rem_shifted >= {1'b0, b_reg});
            
            // Subtract divisor if possible, else keep remainder
            assign rem[i+1] = rem_ge_div ? (rem_shifted - {1'b0, b_reg}) : rem_shifted;
            assign quotient_bits[15 - i] = rem_ge_div ? 1'b1 : 1'b0;
        end
    endgenerate

    // Assemble quotient bits vector from quotient_bits array
    // Note: quotient_bits are generated from MSB to LSB indexing
    wire [15:0] quotient_vector;
    generate
        for (i = 0; i < 16; i = i + 1) begin : quotient_assemble
            assign quotient_vector[i] = quotient_bits[i];
        end
    endgenerate

    // Output assignments
    assign result = quotient_vector;
    assign odd = {8'd0, rem[16][7:0]};  // zero extend remainder to 16 bits

endmodule