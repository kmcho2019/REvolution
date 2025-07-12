module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] result_reg;
    reg en_reg;

    // Combinational product calculation
    wire [15:0] product = 
        (b_reg[0] ? {8'b0, a_reg} : 16'b0) +
        (b_reg[1] ? {7'b0, a_reg, 1'b0} : 16'b0) +
        (b_reg[2] ? {6'b0, a_reg, 2'b0} : 16'b0) +
        (b_reg[3] ? {5'b0, a_reg, 3'b0} : 16'b0) +
        (b_reg[4] ? {4'b0, a_reg, 4'b0} : 16'b0) +
        (b_reg[5] ? {3'b0, a_reg, 5'b0} : 16'b0) +
        (b_reg[6] ? {2'b0, a_reg, 6'b0} : 16'b0) +
        (b_reg[7] ? {1'b0, a_reg, 7'b0} : 16'b0);

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            result_reg <= 16'b0;
            en_reg <= 1'b0;
        end else begin
            // Stage 1: Register inputs
            a_reg <= mul_a;
            b_reg <= mul_b;
            
            // Stage 2: Register result
            result_reg <= product;
            
            // Enable signal pipeline
            en_reg <= mul_en_in;
        end
    end

    // Output assignments
    assign mul_en_out = en_reg;
    assign mul_out = en_reg ? result_reg : 16'b0;

endmodule