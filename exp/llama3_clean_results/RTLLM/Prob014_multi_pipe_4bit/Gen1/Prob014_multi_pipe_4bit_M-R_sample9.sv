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

// Use a generate block to create separate wires for each partial product
genvar i;
wire [2*size-1:0] partial_products [size-1:0];
generate
    for (i = 0; i < size; i++) begin
        assign partial_products[i] = (mul_b[i] == 1'b1) ? (mul_a_ext << i) : {2*size{1'b0}};
    end
endgenerate

// Calculate the final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg1 <= {2*size{1'b0}};
        reg2 <= {2*size{1'b0}};
    end else begin
        reg1 <= partial_products[0];
        for (i = 1; i < size; i++) begin
            reg2 <= reg1 + partial_products[i];
            reg1 <= reg2;
        end
    end
end

// Update the product output
assign mul_out = reg2;

endmodule