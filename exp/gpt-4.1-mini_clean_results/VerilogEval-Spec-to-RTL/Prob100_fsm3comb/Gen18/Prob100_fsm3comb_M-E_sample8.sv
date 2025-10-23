module TopModule (
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding as parameters for readability
    localparam [1:0] A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Function to determine next_state based on current state and input
    function [1:0] get_next_state;
        input [1:0] curr_state;
        input       in_bit;
        begin
            case (curr_state)
                A: get_next_state = in_bit ? B : A;
                B: get_next_state = in_bit ? B : C;
                C: get_next_state = in_bit ? D : A;
                D: get_next_state = in_bit ? B : C;
                default: get_next_state = A;
            endcase
        end
    endfunction

    // Assign next_state using the function
    assign next_state = get_next_state(state, in);

    // Moore output depends only on current state: output is 1 only in state D
    assign out = (state == D);

endmodule