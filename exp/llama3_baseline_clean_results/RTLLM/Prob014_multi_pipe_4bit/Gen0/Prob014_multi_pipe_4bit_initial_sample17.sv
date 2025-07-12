module multi_pipe_4bit #(
    parameter size = 4
) (
    input             clk,
    input             rst_n,
    input  [size-1:0] mul_a,
    input  [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
wire [2*size-1:0] mul_a_ext;
assign mul_a_ext = { {(2*size-size){1'b0}}, mul_a };

// Generate partial products
wire [2*size-1:0] partial_products [size-1:0];
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin
        if (i == 0) begin
            assign partial_products[i] = (mul_b[i] == 1'b1)? mul_a_ext : {(2*size){1'b0}};
        end else begin
            assign partial_products[i] = (mul_b[i] == 1'b1)? { {(i){1'b0}}, mul_a_ext, {(size-i-1){1'b0}} } : {(2*size){1'b0}};
        end
    end
endgenerate

// First level of registers to store intermediate sum values
reg [2*size-1:0] reg1 [size-1:0];
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < size; i++) begin
            reg1[i] <= {(2*size){1'b0}};
        end
    end else begin
        reg1[0] <= partial_products[0];
        for (int i = 1; i < size; i++) begin
            reg1[i] <= reg1[i-1] + partial_products[i];
        end
    end
end

// Second level of registers to store intermediate sum values
reg [2*size-1:0] reg2;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg2 <= {(2*size){1'b0}};
    end else begin
        reg2 <= reg1[size-1];
    end
end

// Output the final product
assign mul_out = reg2;

endmodule