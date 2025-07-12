module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Extended input signals
wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b };

// Partial products
wire [2*size-1:0] partial_products [size-1:0];

// Intermediate sum registers
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;

// Generate block for partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_products[i] = (mul_b_ext[i] == 1'b1)? (mul_a_ext << i) : {2*size{1'b0}};
    end
endgenerate

// Combinational logic for add operation
wire [2*size-1:0] sum_comb;
assign sum_comb = partial_products[0];
for (i = 1; i < size; i++) begin
    assign sum_comb = sum_comb + partial_products[i];
end

// Update registers on positive edge of clock or falling edge of reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg1 <= {2*size{1'b0}};
        sum_reg2 <= {2*size{1'b0}};
    end else begin
        sum_reg1 <= sum_comb;
        sum_reg2 <= sum_reg1;
    end
end

// Calculate final product
assign mul_out = sum_reg2;

endmodule