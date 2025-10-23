module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended multiplicand with size zeros at MSB
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

    // Partial products
    wire [2*size-1:0] pp [size-1:0];

    // Generate partial products
    generate
        genvar i;
        for (i = 0; i < size; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b[i] ? (ext_a << i) : 0;
        end
    endgenerate

    // Pipeline registers
    reg [2*size-1:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;
    reg [2*size-1:0] sum0_reg;
    reg [2*size-1:0] final_sum_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            pp0_reg <= 0;
            pp1_reg <= 0;
            pp2_reg <= 0;
            pp3_reg <= 0;
            sum0_reg <= 0;
            final_sum_reg <= 0;
            mul_out <= 0;
        end else begin
            // Stage 1: Register partial products
            pp0_reg <= pp[0];
            pp1_reg <= pp[1];
            pp2_reg <= pp[2];
            pp3_reg <= pp[3];

            // Stage 2: First level addition
            sum0_reg <= pp0_reg + pp1_reg + pp2_reg;

            // Stage 3: Final addition
            final_sum_reg <= sum0_reg + pp3_reg;

            // Output register
            mul_out <= final_sum_reg;
        end
    end

endmodule