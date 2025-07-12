module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Intermediate registers
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Partial product wires
wire [2*size-1:0] partial_product [size-1:0];

// Initialize partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_product[i] = (mul_b[i])? (mul_a << i) : 'd0;
    end
endgenerate

// Add partial products
wire [2*size-1:0] sum1;
wire [2*size-1:0] sum2;

assign sum1 = partial_product[0] + partial_product[1];
assign sum2 = partial_product[2] + partial_product[3];

// Pipeline registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 'd0;
        reg2 <= 'd0;
    end else begin
        reg1 <= sum1 + sum2;
        reg2 <= reg1;
    end
end

// Final product calculation
assign mul_out = reg2;

endmodule