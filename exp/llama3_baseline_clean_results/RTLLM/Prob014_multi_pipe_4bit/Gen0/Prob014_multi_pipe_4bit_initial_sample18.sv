module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

reg [7:0] partial_product [3:0];
reg [7:0] reg1, reg2;

// Generate partial products
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin
        always @(*) begin
            if (mul_b[i] == 1'b1) begin
                partial_product[i] = {4'd0, mul_a} << i;
            end else begin
                partial_product[i] = 8'd0;
            end
        end
    end
endgenerate

// First level of registers to store intermediate sum values
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 8'd0;
    end else begin
        reg1 <= partial_product[0] + partial_product[1];
    end
end

// Second level of registers to store intermediate sum values
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg2 <= 8'd0;
    end else begin
        reg2 <= reg1 + partial_product[2] + partial_product[3];
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= reg2;
    end
end

endmodule