module TopModule (
    input        clk,
    input        enable,
    input        S,
    input        A,
    input        B,
    input        C,
    output       Z
);

    reg [7:0] shift_reg;

    // Shift left: shift_reg[0] is input bit shifted in; data moves towards MSB (Q[0] at shift_reg[7])
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    // Compute select index inverted since Q[0]=shift_reg[7], Q[7]=shift_reg[0]
    wire [2:0] select = {A, B, C};
    wire [2:0] inv_select = 3'd7 - select;

    assign Z = shift_reg[inv_select];

endmodule