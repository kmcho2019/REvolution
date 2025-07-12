module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

// Extend input signals by adding "size" number of zero bits
wire [7:0] ext_mul_a;
assign ext_mul_a = {4'd0, mul_a};

reg [7:0] partial_product;
reg [7:0] reg1;
reg [7:0] reg2;

// Calculate partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        partial_product <= 8'd0;
    end else begin
        partial_product <= 8'd0;
        for (int i = 0; i < 4; i++) begin
            if (mul_b[i]) begin
                partial_product <= partial_product + (ext_mul_a << i);
            end
        end
    end
end

// Store intermediate sum values
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 8'd0;
    end else begin
        reg1 <= partial_product;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg2 <= 8'd0;
    end else begin
        reg2 <= reg1;
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= reg2;
    end
end

endmodule