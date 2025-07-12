module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Booth encoder signals
    wire [1:0] booth_sel [1:0];
    wire [size:0] booth_pp [2:0];
    wire [size:0] neg_mul_a = {1'b1, ~mul_a} + 1'b1; // Two's complement

    // Booth encoding (radix-4)
    assign booth_sel[0] = {mul_b[1], mul_b[0], 1'b0};
    assign booth_sel[1] = {mul_b[3], mul_b[2], mul_b[1]};

    // Booth partial product selection
    assign booth_pp[0] = (booth_sel[0] == 2'b01) ? {1'b0, mul_a} :
                        (booth_sel[0] == 2'b10) ? neg_mul_a :
                        0;

    assign booth_pp[1] = (booth_sel[1] == 2'b01) ? {mul_a, 1'b0} :
                        (booth_sel[1] == 2'b10) ? {neg_mul_a[size-1:0], 1'b0} :
                        0;

    // Pipeline stage 1 registers (carry-save format)
    reg [size+1:0] stage1_pp0;
    reg [size+1:0] stage1_pp1;
    reg [size+1:0] stage1_sum;
    reg [size+1:0] stage1_carry;

    // Pipeline stage 2 registers
    reg [2*size-1:0] stage2_sum;

    // Stage 1: Booth partial products and carry-save addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_pp0 <= 0;
            stage1_pp1 <= 0;
            stage1_sum <= 0;
            stage1_carry <= 0;
        end else begin
            stage1_pp0 <= booth_pp[0];
            stage1_pp1 <= booth_pp[1];
            // Carry-save addition of first two partial products
            {stage1_carry, stage1_sum} = stage1_pp0 + stage1_pp1;
        end
    end

    // Stage 2: Final addition with carry propagation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= 0;
            mul_out <= 0;
        end else begin
            // Final addition with carry propagation
            stage2_sum <= {stage1_sum, 2'b00} + {stage1_carry, 2'b00};
            mul_out <= stage2_sum;
        end
    end

endmodule