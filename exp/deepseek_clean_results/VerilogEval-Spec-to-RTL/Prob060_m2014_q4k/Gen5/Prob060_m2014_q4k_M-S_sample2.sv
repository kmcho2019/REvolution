module TopModule (
    input clk,
    input resetn,
    input in,
    output reg out
);

    reg [2:0] shift_reg;

    always @(posedge clk) begin
        {out, shift_reg} <= !resetn ? 4'b0 : {shift_reg, in};
    end

endmodule