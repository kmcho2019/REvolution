module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b };

// Use a generate block to perform multiplication for each bit position of the multiplier
genvar i;
generate
    for (i = 0; i < size; i++) begin
        wire [2*size-1:0] partial_product;
        assign partial_product = (mul_b_ext[i] == 1'b1) ? (mul_a_ext << i) : {2*size{1'b0}};
        
        // Add of partial products
        if (i == 0) begin
            assign reg1 = (rst_n == 1'b0) ? {2*size{1'b0}} : (clk == 1'b1) ? partial_product : reg1;
        end else begin
            wire [2*size-1:0] add_result;
            assign add_result = reg1 + partial_product;
            assign reg2 = (rst_n == 1'b0) ? {2*size{1'b0}} : (clk == 1'b1) ? add_result : reg2;
            assign reg1 = (rst_n == 1'b0) ? {2*size{1'b0}} : (clk == 1'b1) ? reg2 : reg1;
        end
    end
endgenerate

// Final product calculation
assign mul_out = (rst_n == 1'b0) ? {2*size{1'b0}} : (clk == 1'b1) ? reg1 : mul_out;

endmodule