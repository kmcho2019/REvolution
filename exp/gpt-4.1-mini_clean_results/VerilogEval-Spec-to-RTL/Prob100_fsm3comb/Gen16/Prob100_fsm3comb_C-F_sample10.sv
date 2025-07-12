module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding using localparams for clarity
    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    // Function encapsulating the next state logic for clarity and reuse
    function [1:0] f_next_state;
        input [1:0] curr_state;
        input       in_signal;
        begin
            case (curr_state)
                A: f_next_state = in_signal ? B : A;
                B: f_next_state = in_signal ? B : C;
                C: f_next_state = in_signal ? D : A;
                D: f_next_state = in_signal ? B : C;
                default: f_next_state = A; // Defensive default
            endcase
        end
    endfunction

    // Continuous assignments for combinational next_state and Moore output
    assign next_state = f_next_state(state, in);
    assign out = (state == D);

endmodule