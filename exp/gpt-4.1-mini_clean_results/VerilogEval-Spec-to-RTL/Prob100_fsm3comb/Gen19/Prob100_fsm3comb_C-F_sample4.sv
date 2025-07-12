module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding for clarity
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Combinational function to determine next state based on current state and input
    function [1:0] get_next_state;
        input [1:0] curr_state;
        input       inp;
        begin
            case (curr_state)
                A: get_next_state = inp ? B : A;
                B: get_next_state = inp ? B : C;
                C: get_next_state = inp ? D : A;
                D: get_next_state = inp ? B : C;
                default: get_next_state = A; // Defensive default
            endcase
        end
    endfunction

    // Purely combinational continuous assignments using the function
    assign next_state = get_next_state(state, in);

    // Moore output: depends only on current state
    assign out = (state == D);

endmodule