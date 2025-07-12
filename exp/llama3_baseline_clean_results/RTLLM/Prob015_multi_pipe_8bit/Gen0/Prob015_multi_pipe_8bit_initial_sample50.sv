module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;

wire [15:0] temp;

assign mul_en_out = mul_en_out_reg[0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_out_reg <= 16'd0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {1'b1};
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_out_reg <= 16'd0;
    end else begin
        if (mul_en_out_reg[0]) begin
            // Generate partial products and calculate partial sums
            for (int i = 0; i < 8; i++) begin
                if (mul_b_reg[i]) begin
                    temp[7 + i] = mul_a_reg[i] ? 1'b1 : 1'b0;
                end
            end

            // Calculate final product
            for (int i = 0; i < 8; i++) begin
                mul_out_reg <= mul_out_reg + (temp[7 + i] ? (mul_a << i) : 16'd0);
            end
        end else begin
            mul_out_reg <= 16'd0;
        end
    end
end

assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule