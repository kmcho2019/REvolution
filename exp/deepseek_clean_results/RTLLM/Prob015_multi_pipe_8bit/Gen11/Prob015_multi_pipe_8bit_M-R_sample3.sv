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
    reg [7:0] mul_a_reg, mul_b_reg;
    reg [1:0] en_shift_reg;
    reg [15:0] sum_reg;

    // Partial products
    wire [15:0] pp [7:0];
    
    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg[i] ? ({8'b0, mul_a_reg} << i) : 16'b0;
        end
    endgenerate

    // Adder tree
    wire [15:0] sum0 = pp[0] + pp[1] + pp[2] + pp[3];
    wire [15:0] sum1 = pp[4] + pp[5] + pp[6] + pp[7];
    wire [15:0] final_sum = sum0 + sum1;

    // Enable shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_shift_reg <= 2'b00;
        end else begin
            en_shift_reg <= {en_shift_reg[0], mul_en_in};
        end
    end

    // Data pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            sum_reg <= 16'b0;
        end else begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            sum_reg <= final_sum;
        end
    end

    // Continuous output assignments
    assign mul_en_out = en_shift_reg[1];
    assign mul_out = en_shift_reg[1] ? sum_reg : 16'b0;

endmodule