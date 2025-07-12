module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    // Function to perform the arithmetic shift given q, amount and direction
    function [63:0] shift_arith;
        input [63:0] val;
        input [1:0] amt;
        reg sign;
        begin
            sign = val[63];
            case (amt)
                2'b00: shift_arith = val << 1;  // shift left by 1
                2'b01: shift_arith = val << 8;  // shift left by 8
                2'b10: shift_arith = {sign, val[63:1]};               // shift right by 1 (arithmetic)
                2'b11: shift_arith = {{8{sign}}, val[63:8]};          // shift right by 8 (arithmetic)
                default: shift_arith = val; // default no shift (should not occur)
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_arith(q, amount);
        end
        // else retain q
    end

endmodule