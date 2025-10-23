module sub_64bit (
    input wire clk,
    input wire enable,
    input wire signed [63:0] A,
    input wire signed [63:0] B,
    output reg signed [63:0] result,
    output reg overflow
);

    // Pipeline registers
    reg signed [31:0] A_low, A_high;
    reg signed [31:0] B_low, B_high;
    reg carry_in;
    
    // Intermediate results
    wire signed [32:0] sum_low;  // Extra bit for carry
    wire signed [31:0] sum_high;
    wire final_carry;
    
    // Stage 1: 32-bit low word subtraction with carry lookahead
    assign sum_low = {A_low[31], A_low} - {B_low[31], B_low} - {31'b0, carry_in};
    
    // Stage 2: 32-bit high word subtraction with carry in
    assign {final_carry, sum_high} = {A_high[31], A_high} - {B_high[31], B_high} - {31'b0, sum_low[32]};
    
    // Overflow detection using XOR (more efficient than comparison)
    wire ovf = (A[63] ^ B[63]) & (A[63] ^ sum_high[31]);
    
    always @(posedge clk) begin
        if (enable) begin
            // Pipeline stage 1
            A_low <= A[31:0];
            A_high <= A[63:32];
            B_low <= B[31:0];
            B_high <= B[63:32];
            carry_in <= 1'b0;
            
            // Pipeline stage 2
            result <= {sum_high, sum_low[31:0]};
            overflow <= ovf;
        end
    end

endmodule