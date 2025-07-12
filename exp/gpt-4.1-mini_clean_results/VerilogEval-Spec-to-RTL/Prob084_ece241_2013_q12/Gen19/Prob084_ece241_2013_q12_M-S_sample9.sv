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

    always @(posedge clk) begin
        if (enable)
            shift_reg <= {S, shift_reg[7:1]};
    end

    wire [2:0] select = {A, B, C};
    // Invert bits to index from MSB side, Q[0] = shift_reg[7]
    wire [2:0] inv_select = ~select;

    assign Z = shift_reg[inv_select];

endmodule