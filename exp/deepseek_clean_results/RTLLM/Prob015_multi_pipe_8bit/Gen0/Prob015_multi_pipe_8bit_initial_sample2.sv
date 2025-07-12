module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline stage 1 registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg en_reg1;

// Partial products
wire [7:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;

// Pipeline stage 2 registers
reg [15:0] sum0, sum1, sum2, sum3;
reg en_reg2;

// Pipeline stage 3 registers
reg [15:0] sum4, sum5;
reg en_reg3;

// Pipeline stage 4 registers
reg [15:0] sum6;
reg en_reg4;

// Generate partial products
assign pp0 = mul_b_reg[0] ? mul_a_reg : 8'b0;
assign pp1 = mul_b_reg[1] ? mul_a_reg : 8'b0;
assign pp2 = mul_b_reg[2] ? mul_a_reg : 8'b0;
assign pp3 = mul_b_reg[3] ? mul_a_reg : 8'b0;
assign pp4 = mul_b_reg[4] ? mul_a_reg : 8'b0;
assign pp5 = mul_b_reg[5] ? mul_a_reg : 8'b0;
assign pp6 = mul_b_reg[6] ? mul_a_reg : 8'b0;
assign pp7 = mul_b_reg[7] ? mul_a_reg : 8'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        en_reg1 <= 1'b0;
        sum0 <= 16'b0;
        sum1 <= 16'b0;
        sum2 <= 16'b0;
        sum3 <= 16'b0;
        en_reg2 <= 1'b0;
        sum4 <= 16'b0;
        sum5 <= 16'b0;
        en_reg3 <= 1'b0;
        sum6 <= 16'b0;
        en_reg4 <= 1'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        // Pipeline stage 1: Register inputs
        en_reg1 <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Pipeline stage 2: First level of additions
        en_reg2 <= en_reg1;
        sum0 <= {8'b0, pp0} + {7'b0, pp1, 1'b0};
        sum1 <= {6'b0, pp2, 2'b0} + {5'b0, pp3, 3'b0};
        sum2 <= {4'b0, pp4, 4'b0} + {3'b0, pp5, 5'b0};
        sum3 <= {2'b0, pp6, 6'b0} + {1'b0, pp7, 7'b0};

        // Pipeline stage 3: Second level of additions
        en_reg3 <= en_reg2;
        sum4 <= sum0 + sum1;
        sum5 <= sum2 + sum3;

        // Pipeline stage 4: Final addition
        en_reg4 <= en_reg3;
        sum6 <= sum4 + sum5;

        // Output stage
        mul_en_out <= en_reg4;
        mul_out <= sum6;
    end
end

endmodule