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
reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;
reg [2*size-1:0] final_product;

// Generate block to perform multiplication for each bit position
genvar i;
generate
    for (i = 0; i < size; i++) begin
        if (mul_b[i]) begin
            assign partial_product[i] = {mul_a, {size-1{i}}};
        end else begin
            assign partial_product[i] = {2*size{1'b0}};
        end
    end
endgenerate

// Add partial products using registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= {2*size{1'b0}};
    end else begin
        sum_reg1 <= partial_product[0];
        for (int j = 1; j < size; j++) begin
            sum_reg1 <= sum_reg1 + partial_product[j];
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg2 <= {2*size{1'b0}};
    end else begin
        sum_reg2 <= sum_reg1;
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        final_product <= {2*size{1'b0}};
    end else begin
        final_product <= sum_reg2;
    end
end

// Assign final product to output
assign mul_out = final_product;

endmodule