module multi_pipe_8bit(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    input mul_en_in, // Input enable signal
    input [7:0] mul_a, // Input multiplicand
    input [7:0] mul_b, // Input multiplier
    output mul_en_out, // Output enable signal
    output [15:0] mul_out // Product output
);

reg [7:0] mul_a_reg; // Register to store input multiplicand
reg [7:0] mul_b_reg; // Register to store input multiplier
reg mul_en_out_reg; // Register to store output enable signal
reg [15:0] mul_out_reg; // Register to store final product
reg [15:0] sum [7:0]; // Registers to store partial sums

// Input control and registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= mul_en_in;
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Partial product generation and partial sum calculation
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        always @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                sum[i] <= 16'b0;
            end else begin
                if (mul_b_reg[i]) begin
                    sum[i] <= {8'b0, mul_a_reg} << i;
                end else begin
                    sum[i] <= 16'b0;
                end
            end
        end
    end
endgenerate

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        mul_out_reg <= sum[0] + sum[1] + sum[2] + sum[3] + sum[4] + sum[5] + sum[6] + sum[7];
    end
end

// Output assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg)? mul_out_reg : 16'b0;

endmodule