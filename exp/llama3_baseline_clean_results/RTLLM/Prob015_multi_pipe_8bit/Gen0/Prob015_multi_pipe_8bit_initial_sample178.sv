module multi_pipe_8bit(
    input clk,        // Clock signal
    input rst_n,      // Active-low reset signal
    input mul_en_in,  // Input enable signal
    input [7:0] mul_a, // Input multiplicand
    input [7:0] mul_b, // Input multiplier
    output mul_en_out, // Output enable signal
    output [15:0] mul_out  // Product output
);

// Internal signals
reg [7:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] temp [7:0]; // Array to hold partial products
reg [15:0] sum [7:0];  // Array to hold partial sums
reg [15:0] mul_out_reg;

// Input control stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 8'd0;
    end else begin
        mul_en_out_reg <= {mul_en_in, mul_en_out_reg[7:1]};
    end
end

// Output enable signal
assign mul_en_out = mul_en_out_reg[7];

// Input registers stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Partial product generation stage
genvar i;
generate
    for (i = 0; i < 8; i++) begin: partial_product_loop
        always @(posedge clk) begin
            if (mul_b_reg[i]) begin
                temp[i] <= {8'd0, mul_a_reg} << i;
            end else begin
                temp[i] <= 16'd0;
            end
        end
    end
endgenerate

// Partial sum calculation stage
always @(posedge clk) begin
    sum[0] <= temp[0];
    for (int i = 1; i < 8; i++) begin
        sum[i] <= sum[i-1] + temp[i];
    end
end

// Final product calculation stage
always @(posedge clk) begin
    mul_out_reg <= sum[7];
end

// Output assignment stage
assign mul_out = (mul_en_out) ? mul_out_reg : 16'd0;

endmodule