module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

wire [2*size-1:0] partial_product [size-1:0];

integer i;

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
wire [2*size-1:0] mul_a_ext = {size{1'b0}} ^ mul_a;
wire [2*size-1:0] mul_b_ext = {size{1'b0}} ^ mul_b;

// Generate block to perform multiplication for each bit position of the multiplier
genvar j;
generate
    for (j = 0; j < size; j = j + 1) begin
        if (mul_b_ext[j] == 1'b1) begin
            assign partial_product[j] = mul_a_ext << j;
        end else begin
            assign partial_product[j] = 'd0;
        end
    end
endgenerate

// First level of registers to store intermediate sum values
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 'd0;
    end else begin
        reg1 <= partial_product[0];
        for (i = 1; i < size; i = i + 1) begin
            reg1 <= reg1 + partial_product[i];
        end
    end
end

// Second level of registers to store intermediate sum values
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg2 <= 'd0;
    end else begin
        reg2 <= reg1;
    end
end

// Assign the product output with the final product
assign mul_out = reg2;

endmodule