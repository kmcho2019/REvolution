module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg       mul_en_reg;

    // Pipeline register for output product and enable
    reg [15:0] mul_out_reg;
    reg        mul_en_out_reg;

    // Partial products - combinational wires
    wire [15:0] pp [7:0];
    assign pp[0] = mul_b_reg[0] ? (mul_a_reg << 0) : 16'd0;
    assign pp[1] = mul_b_reg[1] ? (mul_a_reg << 1) : 16'd0;
    assign pp[2] = mul_b_reg[2] ? (mul_a_reg << 2) : 16'd0;
    assign pp[3] = mul_b_reg[3] ? (mul_a_reg << 3) : 16'd0;
    assign pp[4] = mul_b_reg[4] ? (mul_a_reg << 4) : 16'd0;
    assign pp[5] = mul_b_reg[5] ? (mul_a_reg << 5) : 16'd0;
    assign pp[6] = mul_b_reg[6] ? (mul_a_reg << 6) : 16'd0;
    assign pp[7] = mul_b_reg[7] ? (mul_a_reg << 7) : 16'd0;

    // Sum all partial products combinationally
    wire [15:0] sum_all;
    assign sum_all = pp[0] + pp[1] + pp[2] + pp[3] + pp[4] + pp[5] + pp[6] + pp[7];

    // Stage 1: Register inputs and input enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg   <= 8'd0;
            mul_b_reg   <= 8'd0;
            mul_en_reg  <= 1'b0;
        end else begin
            if (mul_en_in) begin
                mul_a_reg  <= mul_a;
                mul_b_reg  <= mul_b;
            end
            mul_en_reg <= mul_en_in;
        end
    end

    // Stage 2: Compute output product and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg    <= 16'd0;
            mul_en_out_reg <= 1'b0;
        end else begin
            if (mul_en_reg) begin
                mul_out_reg    <= sum_all;
                mul_en_out_reg <= 1'b1;
            end else begin
                mul_out_reg    <= 16'd0;
                mul_en_out_reg <= 1'b0;
            end
        end
    end

    // Output assignments
    assign mul_out     = mul_en_out_reg ? mul_out_reg : 16'd0;
    assign mul_en_out  = mul_en_out_reg;

endmodule