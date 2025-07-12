module TopModule (
    input        x,
    input  [2:0] y,     // present state
    output       Y0,
    output       z
);

    // Function to determine the next state based on present state and input x
    function [2:0] get_next_state;
        input [2:0] curr_state;
        input       in_x;
        begin
            case (curr_state)
                3'b000: get_next_state = (in_x == 1'b0) ? 3'b000 : 3'b001;
                3'b001: get_next_state = (in_x == 1'b0) ? 3'b001 : 3'b100;
                3'b010: get_next_state = (in_x == 1'b0) ? 3'b010 : 3'b001;
                3'b011: get_next_state = (in_x == 1'b0) ? 3'b001 : 3'b010;
                3'b100: get_next_state = (in_x == 1'b0) ? 3'b011 : 3'b100;
                default: get_next_state = 3'b000;  // safe fallback state
            endcase
        end
    endfunction

    wire [2:0] next_state = get_next_state(y, x);

    // Output Y0 is the LSB of the next state
    assign Y0 = next_state[0];

    // Output z is high only for present states 3 (011) and 4 (100)
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule