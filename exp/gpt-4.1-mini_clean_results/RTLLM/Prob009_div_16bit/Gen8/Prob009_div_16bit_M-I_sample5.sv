module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output wire [15:0] result,  // Quotient
    output wire [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Combinational registers holding inputs (as requested)
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Remainder signals: 8-bit wide, from step 0 (0) to step 16
    wire [7:0] rem [0:16];
    wire       quotient_bits [15:0];

    assign rem[0] = 8'd0;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : div_loop
            // Shift remainder left by 1 bit and bring in next dividend bit
            wire [8:0] rem_shifted_ext = {rem[i], a_reg[15 - i]};
            // Subtract divisor from rem_shifted_ext (9 bits) 
            wire [8:0] diff = rem_shifted_ext - {1'b0, b_reg};
            // quotient bit = 1 if no borrow (MSB of diff == 0), else 0
            wire q_bit = ~diff[8];
            assign quotient_bits[15 - i] = q_bit;
            // next remainder is diff[7:0] if q_bit==1 else rem_shifted_ext[7:0]
            assign rem[i+1] = q_bit ? diff[7:0] : rem_shifted_ext[7:0];
        end
    endgenerate

    // Assemble quotient vector (MSB first)
    wire [15:0] quotient_vector;
    generate
        for (i = 0; i < 16; i = i + 1) begin : quotient_assemble
            assign quotient_vector[i] = quotient_bits[i];
        end
    endgenerate

    assign result = quotient_vector;
    assign odd = {8'd0, rem[16]};  // zero-extend remainder to 16 bits

endmodule