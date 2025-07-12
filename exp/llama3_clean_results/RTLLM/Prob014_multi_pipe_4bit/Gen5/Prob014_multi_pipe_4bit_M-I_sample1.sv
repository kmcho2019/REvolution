module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Calculate partial products
wire [2*size-1:0] partial_product [size-1:0];
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_product[i] = (mul_b[i] == 1'b1) ? (mul_a << i) : 'd0;
    end
endgenerate

// Calculate sum of partial products
reg [2*size-1:0] sum;
reg [2*size-1:0] carry;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 0;
        carry <= 0;
    end else begin
        sum <= sum + partial_product[0];
        for (int j = 1; j < size; j++) begin
            sum <= sum + partial_product[j];
        end
        carry <= 0;
    end
end

// Pipeline sum
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 0;
    end else begin
        reg1 <= sum;
    end
end

// Pipeline final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg2 <= 0;
        mul_out <= 0;
    end else begin
        reg2 <= reg1;
        mul_out <= reg2;
    end
end

endmodule