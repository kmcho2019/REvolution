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
    reg enable_reg;

    // Generate all partial products in parallel
    wire [15:0] pp0 = {8'b0, {8{b_reg[0]}} & a_reg};
    wire [15:0] pp1 = {7'b0, {8{b_reg[1]}} & a_reg, 1'b0};
    wire [15:0] pp2 = {6'b0, {8{b_reg[2]}} & a_reg, 2'b0};
    wire [15:0] pp3 = {5'b0, {8{b_reg[3]}} & a_reg, 3'b0};
    wire [15:0] pp4 = {4'b0, {8{b_reg[4]}} & a_reg, 4'b0};
    wire [15:0] pp5 = {3'b0, {8{b_reg[5]}} & a_reg, 5'b0};
    wire [15:0] pp6 = {2'b0, {8{b_reg[6]}} & a_reg, 6'b0};
    wire [15:0] pp7 = {1'b0, {8{b_reg[7]}} & a_reg, 7'b0};

    // Final sum (combinational)
    wire [15:0] final_sum = pp0 + pp1 + pp2 + pp3 + pp4 + pp5 + pp6 + pp7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            result_reg <= 16'b0;
            enable_reg <= 1'b0;
        end else begin
            // Stage 1: Register inputs and enable
            a_reg <= mul_a;
            b_reg <= mul_b;
            enable_reg <= mul_en_in;
            
            // Stage 2: Register final result
            result_reg <= final_sum;
        end
    end

    // Output assignments
    assign mul_en_out = enable_reg;
    assign mul_out = result_reg;

endmodule