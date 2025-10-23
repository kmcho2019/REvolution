module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extend input signals by adding size number of zero bits
wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b };

// Declare registers to store intermediate sum values
reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;

// Generate block to perform multiplication for each bit position
genvar i;
generate
    for (i = 0; i < size; i++) begin
        if (mul_b_ext[i]) begin
            assign partial_product[i] = mul_a_ext << i;
        end else begin
            assign partial_product[i] = 'd0;
        end
    end
endgenerate

// Add of partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= 'd0;
    end else begin
        sum_reg1 <= partial_product[0] + 'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg2 <= 'd0;
    end else begin
        sum_reg2 <= sum_reg1 + partial_product[1] + partial_product[2] + partial_product[3];
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 'd0;
    end else begin
        mul_out <= sum_reg2;
    end
end

endmodule