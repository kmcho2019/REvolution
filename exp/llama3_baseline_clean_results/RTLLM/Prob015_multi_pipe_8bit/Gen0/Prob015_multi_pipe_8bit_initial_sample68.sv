module multi_pipe_8bit (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        mul_en_in,
    input  logic [7:0]  mul_a,
    input  logic [7:0]  mul_b,
    output logic        mul_en_out,
    output logic [15:0] mul_out
);

logic [7:0] mul_en_out_reg;
logic [7:0] mul_a_reg;
logic [7:0] mul_b_reg;

logic [15:0] temp [7:0];

logic [15:0] sum [7:0];

logic [15:0] mul_out_reg;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 8'b0;
        mul_a_reg      <= 8'b0;
        mul_b_reg      <= 8'b0;
        mul_out_reg    <= 16'b0;
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= {1'b1, 7'b0};
            mul_a_reg      <= mul_a;
            mul_b_reg      <= mul_b;
        end else begin
            mul_en_out_reg <= {mul_en_out_reg[6:0], 1'b0};
        end
        mul_out_reg    <= 16'b0;
    end
end

always_comb begin
    for (int i = 0; i < 8; i++) begin
        temp[i] = (mul_b_reg[i] == 1'b1)? (mul_a_reg << i) : 16'b0;
    end
end

always_ff @(posedge clk) begin
    sum[0] <= temp[0];
    for (int i = 1; i < 8; i++) begin
        sum[i] <= sum[i-1] + temp[i];
    end
end

always_ff @(posedge clk) begin
    if (mul_en_out_reg[0]) begin
        mul_out_reg <= sum[7];
    end
end

assign mul_en_out = mul_en_out_reg[7];
assign mul_out    = (mul_en_out)? mul_out_reg : 16'b0;

endmodule