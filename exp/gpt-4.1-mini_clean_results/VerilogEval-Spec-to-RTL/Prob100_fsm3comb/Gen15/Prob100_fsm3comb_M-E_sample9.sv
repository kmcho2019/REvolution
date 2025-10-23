module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // Function to determine next state based on current state and input
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

    // Function to determine output based on current state (Moore output)
    function get_output;
        input [1:0] curr_state;
        begin
            get_output = (curr_state == D) ? 1'b1 : 1'b0;
        end
    endfunction

    // Continuous assignments using the functions
    assign next_state = get_next_state(state, in);
    assign out        = get_output(state);

endmodule