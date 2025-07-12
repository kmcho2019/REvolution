module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input Control
reg [0:0] mul_en_out_reg;

// Input Registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial Product Generation
wire [7:0] temp [7:1];

// Partial Sum Calculation
reg [15:0] sum [7:1];

// Final Product Calculation
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        for (int i = 1; i <= 7; i++) begin
            sum[i] <= 0;
        end
        mul_out_reg <= 0;
    end else begin
        // Input Control
        mul_en_out_reg <= mul_en_in;
        
        // Input Registers
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
        
        // Partial Product Generation
        for (int i = 0; i < 8; i++) begin
            temp[i+1] <= (mul_b_reg[i] ? mul_a_reg : 0);
        end
        
        // Partial Sum Calculation
        for (int i = 1; i <= 7; i++) begin
            sum[i] <= sum[i-1] + {temp[i], {8{i}}};
        end
        
        // Final Product Calculation
        mul_out_reg <= sum[7];
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out ? mul_out_reg : 0);

endmodule