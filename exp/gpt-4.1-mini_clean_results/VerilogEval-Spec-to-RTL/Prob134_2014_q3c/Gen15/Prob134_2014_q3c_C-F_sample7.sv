module TopModule (
    input        clk,    // clock input (not used)
    input        x,
    input  [2:0] y,      // present state
    output       Y0,
    output       z
);

    // Compute next_state using combinational logic in a function for clarity and synthesis friendliness
    function [2:0] next_state_func;
        input [2:0] curr_state;
        input       input_x;
        begin
            case (curr_state)
                3'b000: next_state_func = (input_x == 1'b0) ? 3'b000 : 3'b001;
                3'b001: next_state_func = (input_x == 1'b0) ? 3'b001 : 3'b100;
                3'b010: next_state_func = (input_x == 1'b0) ? 3'b010 : 3'b001;
                3'b011: next_state_func = (input_x == 1'b0) ? 3'b001 : 3'b010;
                3'b100: next_state_func = (input_x == 1'b0) ? 3'b011 : 3'b100;
                default: next_state_func = 3'b000;
            endcase
        end
    endfunction

    wire [2:0] next_state = next_state_func(y, x);

    // Output z is high for states 011 and 100 only
    assign z = (y == 3'b011) || (y == 3'b100);

    // Output Y0 is LSB of next state
    assign Y0 = next_state[0];

endmodule