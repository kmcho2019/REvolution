module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

    // Determine the next state based on the current state and input
    assign next_state = (state == 2'b00) ? (in ? 2'b01 : 2'b00) :
                        (state == 2'b01) ? (in ? 2'b01 : 2'b10) :
                        (state == 2'b10) ? (in ? 2'b11 : 2'b00) :
                        (state == 2'b11) ? (in ? 2'b01 : 2'b10) : 2'b00;

    // Determine the output based on the current state
    // Output is 1 only when the current state is 2'b11
    assign out = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule