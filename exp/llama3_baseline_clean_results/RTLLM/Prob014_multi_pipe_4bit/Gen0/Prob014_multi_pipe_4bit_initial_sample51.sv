module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// extend input signals
wire [2*size-1:0] mul_a_ext;
assign mul_a_ext = { {size{1'b0}}, mul_a };

// first level registers
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// generate partial products
wire [2*size-1:0] partial_product [size];
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_product[i] = (mul_b[i] == 1'b1)? (mul_a_ext << i) : {2*size{1'b0}};
    end
endgenerate

// sum of partial products
wire [2*size-1:0] sum;
assign sum = partial_product[0];
for (i = 1; i < size; i++) begin
    assign sum = sum + partial_product[i];
end

// update registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= {2*size{1'b0}};
        reg2 <= {2*size{1'b0}};
    end else begin
        reg1 <= sum;
        reg2 <= reg1;
    end
end

// final product calculation
assign mul_out = reg2;

endmodule