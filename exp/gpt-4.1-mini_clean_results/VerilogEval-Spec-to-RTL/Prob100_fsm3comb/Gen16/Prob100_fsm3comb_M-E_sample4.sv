module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding parameters
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    // Function to compute next state based on current state and input
    function [1:0] f_next_state(input [1:0] curr_state, input in_bit);
        begin
            case (curr_state)
                A: f_next_state = in_bit ? B : A;
                B: f_next_state = in_bit ? B : C;
                C: f_next_state = in_bit ? D : A;
                D: f_next_state = in_bit ? B : C;
                default: f_next_state = A;
            endcase
        end
    endfunction

    // Continuous assignment of next_state via function call
    assign next_state = f_next_state(state, in);

    // Moore output: output is 1 only in state D (2'b11), else 0
    // Output as bitwise AND of the two bits (both bits high means state D)
    assign out = state[1] & state[0];

endmodule