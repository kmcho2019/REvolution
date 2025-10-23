module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    // Function to perform the arithmetic shift based on amount and direction
    function [63:0] shift_arith;
        input [63:0] val;
        input [1:0]  amt;
        reg sign;
        begin
            sign = val[63];
            case (amt)
                2'b00: shift_arith = {val[62:0], 1'b0};                        // shift left by 1
                2'b01: shift_arith = {val[55:0], 8'b0};                        // shift left by 8
                2'b10: shift_arith = {sign, val[63:1]};                        // shift right by 1 arithmetic
                2'b11: shift_arith = {{8{sign}}, val[63:8]};                   // shift right by 8 arithmetic
                default: shift_arith = val;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shift_arith(q, amount);
        else
            q <= q;
    end

endmodule