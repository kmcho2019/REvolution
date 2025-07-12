module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Intermediate signals
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Extended input signals
wire [2*size-1:0] ext_mul_a;
assign ext_mul_a = { {size{1'b0}}, mul_a };

// Generate block to perform multiplication
wire [2*size-1:0] partial_product [size];
genvar i;
generate
    for (i = 0; i < size; i++) begin
        if (mul_b[i]) begin
            assign partial_product[i] = ext_mul_a << i;
        end else begin
            assign partial_product[i] = { {2*size{1'b0}} };
        end
    end
endgenerate

// Add partial products
wire [2*size-1:0] sum_partial_product;
assign sum_partial_product = partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];

// Register update logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= { {2*size{1'b0}} };
        reg2 <= { {2*size{1'b0}} };
    end else begin
        reg1 <= sum_partial_product;
        reg2 <= reg1;
    end
end

// Final product calculation
assign mul_out = reg2;

endmodule