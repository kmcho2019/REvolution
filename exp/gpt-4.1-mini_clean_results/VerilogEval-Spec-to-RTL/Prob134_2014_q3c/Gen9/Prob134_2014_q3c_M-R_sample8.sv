module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Function to determine the next state Y based on current y and input x
    function [2:0] get_next_state;
        input [2:0] curr_y;
        input       in_x;
        begin
            case (curr_y)
                3'b000: get_next_state = (in_x == 1'b0) ? 3'b000 : 3'b001;
                3'b001: get_next_state = (in_x == 1'b0) ? 3'b001 : 3'b100;
                3'b010: get_next_state = (in_x == 1'b0) ? 3'b010 : 3'b001;
                3'b011: get_next_state = (in_x == 1'b0) ? 3'b001 : 3'b010;
                3'b100: get_next_state = (in_x == 1'b0) ? 3'b011 : 3'b100;
                default: get_next_state = 3'b000;
            endcase
        end
    endfunction

    wire [2:0] Y_next;
    assign Y_next = get_next_state(y, x);

    assign Y0 = Y_next[0];
    assign z  = (y == 3'b011) || (y == 3'b100);

endmodule