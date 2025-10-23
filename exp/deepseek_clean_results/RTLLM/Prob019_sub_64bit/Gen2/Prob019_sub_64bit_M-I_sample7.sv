module sub_64bit (
    input clk,
    input enable,
    input signed [63:0] A,
    input signed [63:0] B,
    output reg signed [63:0] result,
    output reg overflow
);

    // Pipeline registers with clock gating
    reg signed [63:0] A_reg, B_reg;
    reg gated_clk;

    // Clock gating logic
    always @(*) begin
        gated_clk = clk & enable;
    end

    // Stage 1: Register inputs
    always @(posedge gated_clk) begin
        A_reg <= A;
        B_reg <= B;
    end

    // Stage 2: Perform subtraction and overflow detection
    wire signed [63:0] result_wire = A_reg - B_reg;
    wire overflow_wire = (A_reg[63] ^ B_reg[63]) & (A_reg[63] ^ result_wire[63]);

    always @(posedge gated_clk) begin
        result <= result_wire;
        overflow <= overflow_wire;
    end

endmodule