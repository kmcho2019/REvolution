module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Local constants for clarity
    localparam ext_width = 2*size;

    // Zero-extended inputs (only extend when needed)
    wire [ext_width-1:0] ext_a = {{(size){1'b0}}, mul_a};
    wire [ext_width-1:0] ext_b = {{(size){1'b0}}, mul_b};

    // Partial products generation (conditional, power-optimized)
    wire [ext_width-1:0] pp [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = ext_b[i] ? (ext_a << i) : {ext_width{1'b0}};
        end
    endgenerate

    // Pipeline Stage 1: Carry-save addition (pp0 + pp1 -> sum/carry)
    wire [ext_width-1:0] sum1 = pp[0] ^ pp[1];
    wire [ext_width-1:0] carry1 = (pp[0] & pp[1]) << 1;
    reg [ext_width-1:0] sum1_reg, carry1_reg;

    // Pipeline Stage 2: Final addition (sum + carry + remaining PPs)
    wire [ext_width-1:0] sum2 = sum1_reg + carry1_reg + pp[2] + pp[3];
    reg [ext_width-1:0] sum2_reg;

    // Pipeline registers with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1_reg <= {ext_width{1'b0}};
            carry1_reg <= {ext_width{1'b0}};
            sum2_reg <= {ext_width{1'b0}};
            mul_out <= {ext_width{1'b0}};
        end else begin
            sum1_reg <= sum1;
            carry1_reg <= carry1;
            sum2_reg <= sum2;
            mul_out <= sum2_reg;  // Registered output
        end
    end

endmodule