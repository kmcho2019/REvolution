module multi_pipe_4bit #(
    parameter size = 4
)(
    input  logic           clk,
    input  logic           rst_n,
    input  logic [size-1:0] mul_a,
    input  logic [size-1:0] mul_b,
    output logic [2*size-1:0] mul_out
);

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
logic [2*size-1:0] extended_a;
assign extended_a = { {size{1'b0}}, mul_a };

logic [2*size-1:0] extended_b;
assign extended_b = { {size{1'b0}}, mul_b };

// Generate block to perform multiplication for each bit position of the multiplier
logic [2*size-1:0] partial_product [size-1:0];

genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin
        // Calculate partial product
        if (i == 0) begin
            assign partial_product[i] = (mul_b[i]) ? extended_a : 'd0;
        end else begin
            assign partial_product[i] = (mul_b[i]) ? (extended_a << i) : 'd0;
        end
    end
endgenerate

// Registers to store intermediate sum values
logic [2*size-1:0] sum_reg1 [size-1:0];
logic [2*size-1:0] sum_reg2;

// Perform add operations on the positive edge of the clock signal or the falling edge of the reset signal
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition, set registers to 0
        for (int i = 0; i < size; i = i + 1) begin
            sum_reg1[i] <= 'd0;
        end
        sum_reg2 <= 'd0;
    end else begin
        // Update registers with the sum of the corresponding partial products
        sum_reg1[0] <= partial_product[0];
        for (int i = 1; i < size; i = i + 1) begin
            sum_reg1[i] <= sum_reg1[i-1] + partial_product[i];
        end
        sum_reg2 <= sum_reg1[size-1];
    end
end

// Calculate final product on the positive edge of the clock signal or the falling edge of the reset signal
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition, set product output to 0
        mul_out <= 'd0;
    end else begin
        // Update product output with the sum of registers
        mul_out <= sum_reg2;
    end
end

endmodule