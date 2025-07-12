module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

// Function to compute next state based on current state and input
function [1:0] get_next_state;
    input [1:0] curr_state;
    input       in_signal;
    begin
        case (curr_state)
            2'b00: get_next_state = (in_signal == 1'b0) ? 2'b00 : 2'b01; // A
            2'b01: get_next_state = (in_signal == 1'b0) ? 2'b10 : 2'b01; // B
            2'b10: get_next_state = (in_signal == 1'b0) ? 2'b00 : 2'b11; // C
            2'b11: get_next_state = (in_signal == 1'b0) ? 2'b10 : 2'b01; // D
            default: get_next_state = 2'b00;
        endcase
    end
endfunction

// Function to compute output based on current state (Moore output)
function get_output;
    input [1:0] curr_state;
    begin
        case (curr_state)
            2'b11: get_output = 1'b1; // D outputs 1
            default: get_output = 1'b0;
        endcase
    end
endfunction

assign next_state = get_next_state(state, in);
assign out = get_output(state);

endmodule