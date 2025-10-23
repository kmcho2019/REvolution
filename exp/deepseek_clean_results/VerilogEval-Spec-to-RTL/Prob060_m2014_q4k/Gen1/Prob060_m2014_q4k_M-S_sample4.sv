module TopModule (
    input clk,
    input resetn,
    input in,
    output reg out
);

    reg [2:0] shift_reg;

    always @(posedge clk) begin
        if (!resetn) {shift_reg, out} <= 4'b0;
        else {shift_reg, out} <= {shift_reg[1:0], in, shift_reg[2]};
    end

endmodule