module multi_pipe_4bit #(
    parameter size = 4  // Explicit parameter declaration with default value
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Input registers to reduce switching activity
    reg [size-1:0] mul_a_reg, mul_b_reg;

    // Partial products generation (optimized without zero-padding)
    wire [2*size-1:0] pp [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg[i] ? (mul_a_reg << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline Stage 1: First level of addition (pp0 + pp1) and (pp2 + pp3)
    wire [2*size-1:0] sum0 = pp[0] + pp[1];
    wire [2*size-1:0] sum1 = pp[2] + pp[3];
    reg [2*size-1:0] sum0_reg, sum1_reg;

    // Pipeline Stage 2: Final addition (sum0 + sum1)
    wire [2*size-1:0] final_sum = sum0_reg + sum1_reg;
    reg [2*size-1:0] final_sum_reg;

    // Pipeline registers with proper reset and clock gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= {size{1'b0}};
            mul_b_reg <= {size{1'b0}};
            sum0_reg <= {(2*size){1'b0}};
            sum1_reg <= {(2*size){1'b0}};
            final_sum_reg <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            sum0_reg <= sum0;        // Stage 1 -> Stage 2
            sum1_reg <= sum1;        // Stage 1 -> Stage 2
            final_sum_reg <= final_sum; // Stage 2 -> Output
            mul_out <= final_sum_reg;  // Registered output
        end
    end

endmodule