module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Combinational function to compute next_state from present state y and input x
    function [2:0] next_state_f;
        input [2:0] curr_y;
        input       curr_x;
        begin
            case (curr_y)
                3'b000: next_state_f = (curr_x == 1'b0) ? 3'b000 : 3'b001;
                3'b001: next_state_f = (curr_x == 1'b0) ? 3'b001 : 3'b100;
                3'b010: next_state_f = (curr_x == 1'b0) ? 3'b010 : 3'b001;
                3'b011: next_state_f = (curr_x == 1'b0) ? 3'b001 : 3'b010;
                3'b100: next_state_f = (curr_x == 1'b0) ? 3'b011 : 3'b100;
                default: next_state_f = 3'b000; // safe default
            endcase
        end
    endfunction

    wire [2:0] next_state = next_state_f(y, x);

    assign z = (y == 3'b011) || (y == 3'b100);
    assign Y0 = next_state[0];

endmodule