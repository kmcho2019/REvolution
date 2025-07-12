module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

reg [7:0] reg1;
reg [7:0] reg2;

// Extend input signals
wire [7:0] ext_a = {4'd0, mul_a};
wire [7:0] ext_b = {4'd0, mul_b};

// Generate partial products
wire [7:0] partial_product [3:0];
genvar i;
generate
    for (i = 0; i < 4; i++) begin
        always @(*) begin
            if (ext_b[i])
                partial_product[i] = ext_a << i;
            else
                partial_product[i] = 8'd0;
        end
    end
endgenerate

// Add partial products and store in registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg1 <= 8'd0;
        reg2 <= 8'd0;
    end else begin
        reg1 <= partial_product[0] + partial_product[1];
        reg2 <= partial_product[2] + partial_product[3];
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_out <= 8'd0;
    else
        mul_out <= reg1 + reg2;
end

endmodule