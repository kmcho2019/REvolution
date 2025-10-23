module multi_pipe_8bit(
    input               clk,        // Clock signal
    input               rst_n,      // Active-low reset signal
    input               mul_en_in,  // Input enable signal
    input  [7:0]        mul_a,      // Multiplicand
    input  [7:0]        mul_b,      // Multiplier
    output reg           mul_en_out, // Output enable signal
    output reg [15:0]    mul_out     // Product output
);

// Internal signals and registers
reg [7:0] mul_a_reg;        // Register for storing the multiplicand
reg [7:0] mul_b_reg;        // Register for storing the multiplier
reg [7:0] mul_en_out_reg;   // Register for storing the output enable signal
wire [15:0] temp [7:0];     // Wires for partial products
reg [15:0] sum [7:0];       // Registers for partial sums
reg [15:0] mul_out_reg;     // Register for the final product

// Input control and registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 8'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= {1'b1, 7'b0}; // Set the MSB to indicate multiplication is enabled
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end else begin
            mul_en_out_reg <= {mul_en_out_reg[6:0], 1'b0}; // Shift the enable signal
        end
    end
end

// Partial product generation
genvar i;
generate
    for (i = 0; i < 8; i++) begin: partial_product_generation
        assign temp[i] = (mul_b_reg[i] == 1'b1) ? {8'b0, mul_a_reg} : 16'b0;
    end
endgenerate

// Partial sum calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < 8; i++) begin
            sum[i] <= 16'b0;
        end
    end else begin
        for (int i = 0; i < 8; i++) begin
            if (i == 0) begin
                sum[i] <= temp[0];
            end else begin
                sum[i] <= sum[i-1] + temp[i];
            end
        end
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        mul_out_reg <= sum[7];
    end
end

// Output assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else begin
        mul_en_out <= mul_en_out_reg[7]; // MSB indicates if the product is valid
        if (mul_en_out) begin
            mul_out <= mul_out_reg;
        end else begin
            mul_out <= 16'b0;
        end
    end
end

endmodule