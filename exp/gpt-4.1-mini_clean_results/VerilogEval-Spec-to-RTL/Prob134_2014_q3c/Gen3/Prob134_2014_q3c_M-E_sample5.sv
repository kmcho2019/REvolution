module TopModule (
    input        clk,   // clock input (not used)
    input        x,
    input  [2:0] y,     // present state
    output       Y0,
    output       z
);

    // Function to return next state based on present state and input x
    function [2:0] get_next_state;
        input [2:0] curr_state;
        input       x_in;
        begin
            case (curr_state)
                3'b000: get_next_state = (x_in == 1'b0) ? 3'b000 : 3'b001;
                3'b001: get_next_state = (x_in == 1'b0) ? 3'b001 : 3'b100;
                3'b010: get_next_state = (x_in == 1'b0) ? 3'b010 : 3'b001;
                3'b011: get_next_state = (x_in == 1'b0) ? 3'b001 : 3'b010;
                3'b100: get_next_state = (x_in == 1'b0) ? 3'b011 : 3'b100;
                default: get_next_state = 3'b000;
            endcase
        end
    endfunction

    // Function to return output z based on present state
    function get_z;
        input [2:0] curr_state;
        begin
            case (curr_state)
                3'b000, 3'b001, 3'b010: get_z = 1'b0;
                3'b011, 3'b100:         get_z = 1'b1;
                default:                get_z = 1'b0;
            endcase
        end
    endfunction

    wire [2:0] next_state;
    assign next_state = get_next_state(y, x);
    assign Y0 = next_state[0];
    assign z = get_z(y);

endmodule