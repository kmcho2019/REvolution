module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline registers for control signals
    reg [2:0] enable_pipe;

    // Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products
    wire [7:0] pp [0:7];

    // Stage 1: Generate partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg[i] ? mul_a_reg : 8'b0;
        end
    endgenerate

    // Stage 2: First level of reduction (Wallace tree)
    wire [11:0] sum1, carry1;
    assign sum1 = {3'b0, pp[0]} + {2'b0, pp[1], 1'b0} + {1'b0, pp[2], 2'b0};
    assign carry1 = {3'b0, pp[3]} + {2'b0, pp[4], 1'b0} + {1'b0, pp[5], 2'b0};

    // Stage 2 registers
    reg [11:0] sum1_reg;
    reg [11:0] carry1_reg;
    reg [15:0] pp6_reg;
    reg [15:0] pp7_reg;

    // Stage 3: Second level of reduction
    wire [15:0] sum2;
    assign sum2 = {4'b0, sum1_reg} + {4'b0, carry1_reg} + pp6_reg + {pp7_reg, 1'b0};

    // Output register
    reg [15:0] product_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            enable_pipe <= 3'b0;
            sum1_reg <= 12'b0;
            carry1_reg <= 12'b0;
            pp6_reg <= 16'b0;
            pp7_reg <= 16'b0;
            product_reg <= 16'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Pipeline control signals
            enable_pipe <= {enable_pipe[1:0], mul_en_in};

            // Stage 1: Register inputs
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Stage 2: Register first reduction results
            sum1_reg <= sum1;
            carry1_reg <= carry1;
            pp6_reg <= {8'b0, pp[6]};
            pp7_reg <= {8'b0, pp[7]};

            // Stage 3: Final addition and output
            product_reg <= sum2;

            // Output assignment
            mul_en_out <= enable_pipe[2];
            mul_out <= enable_pipe[2] ? product_reg : 16'b0;
        end
    end

endmodule