module sub_64bit (
    input wire clk,          // Added clock for input registration
    input wire signed [63:0] A,
    input wire signed [63:0] B,
    output wire signed [63:0] result,
    output wire overflow
);

    // Registered inputs to reduce glitching
    reg signed [63:0] A_reg, B_reg;
    always @(posedge clk) begin
        A_reg <= A;
        B_reg <= B;
    end

    // Perform subtraction using explicit carry-lookahead structure
    wire [63:0] carry;
    wire [63:0] sum;

    // First stage
    assign {carry[0], sum[0]} = {A_reg[0], ~B_reg[0]} + 2'b01;
    
    // Subsequent stages with carry lookahead
    genvar i;
    generate
        for (i = 1; i < 64; i = i + 1) begin : sub_stages
            assign {carry[i], sum[i]} = {A_reg[i], ~B_reg[i]} + carry[i-1];
        end
    endgenerate

    assign result = sum;

    // Overflow detection using shared XOR gates
    wire a_sign = A_reg[63];
    wire b_sign = B_reg[63];
    wire r_sign = result[63];
    wire sign_diff = a_sign ^ b_sign;
    
    assign overflow = sign_diff & (a_sign ^ r_sign);

endmodule