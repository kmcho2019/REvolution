module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Next state combinational logic as wire
    wire [2:0] next_state;

    // Compute next_state using assign with case inside a function for clarity and purely combinational approach
    function [2:0] get_next_state;
        input [2:0] curr_state;
        input       input_x;
        begin
            case (curr_state)
                3'b000: get_next_state = (input_x == 1'b0) ? 3'b000 : 3'b001;
                3'b001: get_next_state = (input_x == 1'b0) ? 3'b001 : 3'b100;
                3'b010: get_next_state = (input_x == 1'b0) ? 3'b010 : 3'b001;
                3'b011: get_next_state = (input_x == 1'b0) ? 3'b001 : 3'b010;
                3'b100: get_next_state = (input_x == 1'b0) ? 3'b011 : 3'b100;
                default: get_next_state = 3'b000;
            endcase
        end
    endfunction

    assign next_state = get_next_state(y, x);

    // Output z combinational logic: 1 when y == 3'b011 or 3'b100, else 0
    assign z = (y == 3'b011) || (y == 3'b100);

    // Y0 is next_state[0]
    assign Y0 = next_state[0];

endmodule