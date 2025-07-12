module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    reg [6:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 7'b0;
        end else begin
            shift_reg <= {shift_reg[5:0], in};
        end
    end

    // Pattern matching:
    // disc: 0111110 (5 ones preceded by 0 and followed by 0)
    assign disc = (shift_reg[6:0] == 7'b0111110);

    // flag: 01111110 (6 ones preceded by 0 and followed by 0)
    assign flag = (shift_reg[6:0] == 7'b0111110) && !in;

    // err: 01111111... (7 or more ones)
    assign err = (&shift_reg[5:0]) && in;  // All 6 bits are 1 and current input is 1

endmodule