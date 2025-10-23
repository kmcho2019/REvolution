module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Function to compute next state based on present state and input x
    function [2:0] next_state;
        input [2:0] state;
        input       xin;
        begin
            case (state)
                3'b000: next_state = (xin == 0) ? 3'b000 : 3'b001;
                3'b001: next_state = (xin == 0) ? 3'b001 : 3'b100;
                3'b010: next_state = (xin == 0) ? 3'b010 : 3'b001;
                3'b011: next_state = (xin == 0) ? 3'b001 : 3'b010;
                3'b100: next_state = (xin == 0) ? 3'b011 : 3'b100;
                default: next_state = 3'b000;
            endcase
        end
    endfunction

    wire [2:0] Y = next_state(y, x);

    assign Y0 = Y[0];

    assign z = (y == 3'b011) || (y == 3'b100);

endmodule