module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // State encoding for readability
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // Compute each bit of next_state separately using conditional operators
    // next_state[1] (MSB)
    assign next_state[1] = (state == A) ? 1'b0 :
                           (state == B) ? 1'b1 :
                           (state == C) ? in :
                           (state == D) ? 1'b1 : 1'b0;

    // next_state[0] (LSB)
    assign next_state[0] = (state == A) ? in :
                           (state == B) ? 1'b0 :
                           (state == C) ? 1'b0 :
                           (state == D) ? (in ? 1'b1 : 1'b0) : 1'b0;

    // Output function for clarity and possible reusability
    function automatic bit moore_out(input [1:0] st);
        case (st)
            A, B, C: moore_out = 1'b0;
            D:       moore_out = 1'b1;
            default: moore_out = 1'b0;
        endcase
    endfunction

    assign out = moore_out(state);

endmodule