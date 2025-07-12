module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Extend the input signals by adding "size" number of zero bits at the most significant bit positions
wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };
wire [2*size-1:0] b_ext = { {size{1'b0}}, mul_b };

// Generate partial products
wire [2*size-1:0] partial_products [size-1:0];
genvar i;
generate
    for (i = 0; i < size; i++) begin: partial_product_gen
        assign partial_products[i] = (mul_b[i] == 1'b1) ? (a_ext << i) : {2*size{1'b0}};
    end
endgenerate

// First level of registers
reg [2*size-1:0] reg1 [size-1:0];
integer j;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (j = 0; j < size; j++) begin
            reg1[j] <= {2*size{1'b0}};
        end
    end else begin
        reg1[0] <= partial_products[0];
        for (j = 1; j < size; j++) begin
            reg1[j] <= reg1[j-1] + partial_products[j];
        end
    end
end

// Second level of registers
reg [2*size-1:0] reg2 [size-1:0];
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (j = 0; j < size; j++) begin
            reg2[j] <= {2*size{1'b0}};
        end
    end else begin
        reg2[0] <= reg1[0];
        for (j = 1; j < size; j++) begin
            reg2[j] <= reg2[j-1] + reg1[j];
        end
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= reg2[size-1];
    end
end

endmodule