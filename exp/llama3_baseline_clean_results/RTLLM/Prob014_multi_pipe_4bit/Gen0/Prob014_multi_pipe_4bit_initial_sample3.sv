module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Extended input signals with "size" number of zero bits at the most significant bit positions
reg [2*size-1:0] mul_a_ext;
reg [2*size-1:0] mul_b_ext;

// Pipeline registers
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Partial products
wire [2*size-1:0] partial_product [size];

// Initialize extended input signals
assign mul_a_ext = { {(size){1'b0}}, mul_a };
assign mul_b_ext = { {(size){1'b0}}, mul_b };

// Generate block to perform multiplication for each bit position of the multiplier (mul_b)
genvar i;
generate
    for (i = 0; i < size; i++) begin: partial_product_gen
        if (mul_b_ext[i]) begin
            assign partial_product[i] = { {(size-i){1'b0}}, mul_a, {(i){1'b0}} };
        end else begin
            assign partial_product[i] = 'd0;
        end
    end
endgenerate

// Pipeline logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 'd0;
        reg2 <= 'd0;
    end else begin
        reg1 <= partial_product[0];
        for (int j = 1; j < size; j++) begin
            reg2 <= reg1 + partial_product[j];
        end
    end
end

// Final product calculation
assign mul_out = reg2;

endmodule