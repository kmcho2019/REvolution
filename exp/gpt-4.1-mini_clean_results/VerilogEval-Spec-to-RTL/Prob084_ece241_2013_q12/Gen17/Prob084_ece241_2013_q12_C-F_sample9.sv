module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    reg [7:0] shift_reg;

    // On positive clock edge, if enable is high, shift right inserting S into MSB (Q[0])
    always @(posedge clk) begin
        if (enable)
            shift_reg <= {S, shift_reg[7:1]};
    end

    // Use inverted 3-bit select {A,B,C} to index the shift register:
    // Q[0] is shift_reg[7], Q[7] is shift_reg[0]
    wire [2:0] select = {A, B, C};
    wire [2:0] inv_select = 3'd7 - select;

    assign Z = shift_reg[inv_select];

endmodule