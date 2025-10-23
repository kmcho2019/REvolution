module multi_pipe_8bit(
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg [3:0] counter;
reg mul_en_out_reg;
reg [15:0] temp;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
        counter <= 4'b0;
        mul_en_out_reg <= 1'b0;
    end else begin
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out_reg <= 1'b1;
            counter <= 4'b1;
        end
        if (counter == 4'b8) begin
            mul_en_out_reg <= 1'b0;
            counter <= 4'b0;
        end else if (counter > 4'b0) begin
            counter <= counter + 1'b1;
        end
    end
end

always @(posedge clk) begin
    if (counter == 4'b1) begin
        temp <= 16'b0;
    end else if (counter > 4'b1 && counter < 4'b9) begin
        if (mul_b_reg[counter-2]) begin
            temp <= temp + (mul_a_reg << (counter-1));
        end
    end
    if (counter == 4'b8) begin
        mul_out_reg <= temp;
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg) ? mul_out_reg : 16'b0;

endmodule