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

    // Shift left by 1 on posedge clk with enable, inserting S at LSB (Q[0] is MSB)
    always @(posedge clk) begin
        if (enable)
            shift_reg <= {shift_reg[6:0], S};
    end

    // Output Z selects Q[0]..Q[7] with Q[0]=shift_reg[7], Q[7]=shift_reg[0].
    // So index = inverted {A,B,C} = ~{A,B,C} (3-bit) to get 7 - {A,B,C}
    wire [2:0] select = {A, B, C};
    wire [2:0] inv_select = ~select; // 7 - select

    assign Z = shift_reg[inv_select];

endmodule