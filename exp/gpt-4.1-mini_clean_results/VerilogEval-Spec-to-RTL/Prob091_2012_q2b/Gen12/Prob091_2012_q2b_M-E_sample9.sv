module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Function to calculate all next state inputs from current state y and input w
    function [5:0] next_state_inputs;
        input [5:0] curr_y;
        input       w_in;
        reg   [5:0] nxt;
        reg         wn;
        begin
            wn = ~w_in;
            // Initialize next inputs to zero
            nxt = 6'b0;

            // Transitions to B (y[1]): from A (y[0]) if w=1
            if (curr_y[0] & w_in) nxt[1] = 1'b1;

            // Transitions to D (y[3]): from B (y[1]), C (y[2]), E (y[4]), F (y[5]) if w=0
            if (curr_y[1] & wn) nxt[3] = 1'b1;
            if (curr_y[2] & wn) nxt[3] = 1'b1;
            if (curr_y[4] & wn) nxt[3] = 1'b1;
            if (curr_y[5] & wn) nxt[3] = 1'b1;

            // Note: The other next state inputs are not requested/output here

            next_state_inputs = nxt;
        end
    endfunction

    wire [5:0] nxt_inputs = next_state_inputs(y, w);

    assign Y1 = nxt_inputs[1];
    assign Y3 = nxt_inputs[3];

endmodule