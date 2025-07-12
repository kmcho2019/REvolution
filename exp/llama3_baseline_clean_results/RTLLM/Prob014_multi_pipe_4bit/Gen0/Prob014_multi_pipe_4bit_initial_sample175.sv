module multi_pipe_4bit #(
    parameter size = 4
)(
    input               clk,
    input               rst_n,
    input  [size-1:0]   mul_a,
    input  [size-1:0]   mul_b,
    output [2*size-1:0] mul_out
);

// Extend the input signals by adding "size" number of zero bits at the most significant bit positions
reg [2*size-1:0] a_ext;
reg [2*size-1:0] b_ext;

// Generate block to perform multiplication for each bit position of the multiplier
reg [2*size-1:0] partial_products [size-1:0];

// Registers to store the intermediate sum values
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;

// Product output
reg [2*size-1:0] product;

// Extend the input signals
always @(*) begin
    a_ext = { {(size){1'b0}}, mul_a };
    b_ext = { {(size){1'b0}}, mul_b };
end

// Generate block to perform multiplication for each bit position of the multiplier
genvar i;
generate
    for (i = 0; i < size; i++) begin
        always @(*) begin
            if (b_ext[i] == 1'b1) begin
                partial_products[i] = a_ext << i;
            end else begin
                partial_products[i] = 'd0;
            end
        end
    end
endgenerate

// Calculate the sum of the partial products and store it in sum_reg1
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= 'd0;
    end else begin
        sum_reg1 <= partial_products[0];
    end
end

// Calculate the sum of the partial products and store it in sum_reg2
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg2 <= 'd0;
    end else begin
        reg [2*size-1:0] sum;
        sum = sum_reg1;
        for (int i = 1; i < size; i++) begin
            sum = sum + partial_products[i];
        end
        sum_reg2 <= sum;
    end
end

// Calculate the final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        product <= 'd0;
    end else begin
        product <= sum_reg2;
    end
end

// Assign the final product to the output
assign mul_out = product;

endmodule