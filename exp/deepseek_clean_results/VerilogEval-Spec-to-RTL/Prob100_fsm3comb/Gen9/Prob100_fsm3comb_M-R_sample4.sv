module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// Function to compute next state
function [1:0] get_next_state;
    input [1:0] current_state;
    input in;
    begin
        case (current_state)
            2'b00: get_next_state = in ? 2'b01 : 2'b00; // A -> B if in=1, else A
            2'b01: get_next_state = in ? 2'b01 : 2'b10; // B -> B if in=1, else C
            2'b10: get_next_state = in ? 2'b11 : 2'b00; // C -> D if in=1, else A
            2'b11: get_next_state = in ? 2'b01 : 2'b10; // D -> B if in=1, else C
            default: get_next_state = 2'b00;            // Default to A
        endcase
    end
endfunction

// Output depends only on current state (Moore machine)
assign out = (state == 2'b11); // 1 when in state D

// Next state logic using the function
assign next_state = get_next_state(state, in);

endmodule