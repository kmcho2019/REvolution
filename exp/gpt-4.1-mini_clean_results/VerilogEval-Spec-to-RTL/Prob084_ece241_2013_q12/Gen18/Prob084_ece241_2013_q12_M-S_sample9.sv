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

    // On positive clock edge, if enable is high, shift right inserting S at Q[0] (shift_reg[0])
    always @(posedge clk) begin
        if (enable)
            shift_reg <= {shift_reg[6:0], S};
    end

    // Output Z selects Q[i] = shift_reg[i] based on {A,B,C}
    wire [2:0] select = {A, B, C};
    assign Z = shift_reg[select];

endmodule