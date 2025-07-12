module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] partial_product [7:0];
reg [15:0] accumulator;
reg [2:0] counter;
reg mul_en_out_reg;

// Input Buffering
always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Parallel Partial Product Generation
genvar i;
generate
    for (i = 0; i < 8; i++) begin: partial_product_gen
        always @(posedge clk) begin
            if (!rst_n) begin
                partial_product[i] <= 16'b0;
            end else if (mul_en_in) begin
                partial_product[i] <= (mul_b_reg[i]) ? (mul_a_reg << i) : 16'b0;
            end
        end
    end
endgenerate

// Sequential Accumulator
always @(posedge clk) begin
    if (!rst_n) begin
        accumulator <= 16'b0;
        counter <= 3'b000;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        if (counter == 3'b000) begin
            accumulator <= partial_product[0];
            counter <= counter + 1;
        end else if (counter < 3'b111) begin
            accumulator <= accumulator + partial_product[counter];
            counter <= counter + 1;
        end else begin
            mul_en_out_reg <= 1'b1;
        end
    end else begin
        accumulator <= 16'b0;
        counter <= 3'b000;
        mul_en_out_reg <= 1'b0;
    end
end

// Output assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = accumulator;

endmodule