module multi_pipe_8bit (
    input  clk,
    input  rst_n,
    input  mul_en_in,
    input  [7:0] mul_a,
    input  [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [0:0] mul_en_out_reg;  // Register to store input enable signal
reg [7:0] mul_a_reg;       // Register to store multiplicand
reg [7:0] mul_b_reg;       // Register to store multiplier
reg [15:0] mul_out_reg;    // Register to store final product

// Input Control: Sample input enable signal on positive edge of clock signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else begin
        mul_en_out_reg <= mul_en_in;
    end
end

// Input Registers: Store input multiplicand and multiplier on positive edge of clock signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial Product Generation and Partial Sum Calculation
wire [15:0] temp [7:0];   // Wires to store partial products
reg [15:0] sum [7:0];     // Registers to store partial sums

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < 8; i++) begin
            sum[i] <= 16'b0;
        end
    end else begin
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i]) begin
                temp[i] = {8'b0, mul_a_reg} << i;
                if (i == 0) begin
                    sum[i] <= temp[i];
                end else begin
                    sum[i] <= sum[i-1] + temp[i];
                end
            end else begin
                temp[i] = 16'b0;
                if (i == 0) begin
                    sum[i] <= 16'b0;
                end else begin
                    sum[i] <= sum[i-1];
                end
            end
        end
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        mul_out_reg <= sum[7];
    end
end

// Output Assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg) ? mul_out_reg : 16'b0;

endmodule