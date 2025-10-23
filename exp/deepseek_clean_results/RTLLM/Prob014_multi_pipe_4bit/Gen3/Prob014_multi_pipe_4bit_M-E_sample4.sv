module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended multiplicand with size zeros at MSB
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

    // Booth encoder outputs
    wire [1:0] booth_sel [size/2:0];
    wire [2*size-1:0] booth_pp [size/2:0];

    // Generate booth encoding groups (including implicit -1 bit)
    assign booth_sel[0] = {mul_b[0], 1'b0};
    assign booth_sel[1] = mul_b[2:1];
    assign booth_sel[2] = mul_b[3:2];

    // Generate booth partial products
    generate
        genvar i;
        for (i = 0; i <= size/2; i = i + 1) begin : booth_pp_gen
            always @(*) begin
                case (booth_sel[i])
                    2'b00, 2'b11: booth_pp[i] = 0;
                    2'b01: booth_pp[i] = ext_a << (2*i);
                    2'b10: booth_pp[i] = (~ext_a + 1) << (2*i);
                endcase
            end
        end
    endgenerate

    // Pipeline registers
    reg [2*size-1:0] pp0_reg, pp1_reg, pp2_reg;
    reg [2*size-1:0] sum0_reg, sum1_reg;
    reg [2*size-1:0] final_sum_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            pp0_reg <= 0;
            pp1_reg <= 0;
            pp2_reg <= 0;
            sum0_reg <= 0;
            sum1_reg <= 0;
            final_sum_reg <= 0;
            mul_out <= 0;
        end else begin
            // Stage 1: Register booth partial products
            pp0_reg <= booth_pp[0];
            pp1_reg <= booth_pp[1];
            pp2_reg <= booth_pp[2];

            // Stage 2: Carry-save addition (3:2 compression)
            sum0_reg <= pp0_reg + pp1_reg;
            sum1_reg <= pp2_reg;

            // Stage 3: Final addition
            final_sum_reg <= sum0_reg + sum1_reg;

            // Output register
            mul_out <= final_sum_reg;
        end
    end

endmodule