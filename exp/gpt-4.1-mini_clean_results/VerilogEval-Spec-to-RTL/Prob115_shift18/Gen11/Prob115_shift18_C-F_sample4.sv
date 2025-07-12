module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    // Function to perform arithmetic shift left/right by 1 or 8 bits based on amount
    function [63:0] shift_arith;
        input [63:0] val;
        input [1:0] amt;
        reg msb;
        begin
            msb = val[63];
            case (amt)
                2'b00: // shift left by 1
                    shift_arith = {val[62:0], 1'b0};
                2'b01: // shift left by 8
                    shift_arith = {val[55:0], 8'b0};
                2'b10: // arithmetic shift right by 1
                    shift_arith = {msb, val[63:1]};
                2'b11: // arithmetic shift right by 8
                    shift_arith = {{8{msb}}, val[63:8]};
                default:
                    shift_arith = val; // safe default hold
            endcase
        end
    endfunction

    wire [63:0] next_q = load ? data : (ena ? shift_arith(q, amount) : q);

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule