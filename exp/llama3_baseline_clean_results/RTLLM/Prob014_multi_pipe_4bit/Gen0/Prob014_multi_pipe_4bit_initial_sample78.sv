module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Extend the input signals
wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };

// Generate partial products
wire [2*size-1:0] partial_product [size-1:0];
genvar i;
generate
    for (i = 0; i < size; i++) begin
        if (mul_b[i]) begin
            assign partial_product[i] = ext_mul_a << i;
        end else begin
            assign partial_product[i] = 'd0;
        end
    end
endgenerate

// First level of registers to store intermediate sum values
reg [2*size-1:0] reg1 [size-1:0];
integer j;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (j = 0; j < size; j++) begin
            reg1[j] <= 'd0;
        end
    end else begin
        reg1[0] <= partial_product[0];
        for (j = 1; j < size; j++) begin
            reg1[j] <= reg1[j-1] + partial_product[j];
        end
    end
end

// Second level of registers to store intermediate sum values
reg [2*size-1:0] reg2 [size-1:0];
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (j = 0; j < size; j++) begin
            reg2[j] <= 'd0;
        end
    end else begin
        reg2[0] <= reg1[0];
        for (j = 1; j < size; j++) begin
            reg2[j] <= reg2[j-1] + reg1[j];
        end
    end
end

// Calculate the final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 'd0;
    end else begin
        mul_out <= reg2[size-1];
    end
end

endmodule