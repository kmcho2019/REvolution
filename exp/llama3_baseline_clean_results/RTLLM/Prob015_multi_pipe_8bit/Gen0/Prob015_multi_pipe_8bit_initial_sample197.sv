module multi_pipe_8bit (
    input           clk,        // Clock signal
    input           rst_n,      // Active-low reset signal
    input           mul_en_in, // Input enable signal
    input   [7:0]   mul_a,     // Input multiplicand
    input   [7:0]   mul_b,     // Input multiplier
    output          mul_en_out, // Output enable signal
    output  [15:0]  mul_out    // Product output
);

reg [7:0] mul_en_out_reg; // Register to store input enable signal
reg [7:0] mul_a_reg;     // Register to store input multiplicand
reg [7:0] mul_b_reg;     // Register to store input multiplier
wire [15:0] temp [7:0];  // Wires to store partial products
reg [15:0] sum [7:0];    // Registers to store partial sums
reg [15:0] mul_out_reg;  // Register to store final product

// Input control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {1'b1, 7'b0};
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[6:0], 1'b0};
    end
end

assign mul_en_out = mul_en_out_reg[7];

// Input registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Partial product generation
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign temp[i] = (mul_b_reg[i]? (mul_a_reg << i) : 16'b0);
    end
endgenerate

// Partial sum calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < 8; i++) begin
            sum[i] <= 16'b0;
        end
    end else begin
        sum[0] <= temp[0];
        for (int i = 1; i < 8; i++) begin
            sum[i] <= sum[i-1] + temp[i];
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
assign mul_out = (mul_en_out? mul_out_reg : 16'b0);

endmodule