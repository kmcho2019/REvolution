module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic
    assign out = state[3]; // Output is '1' only when state is 'D' (4'b1000)

    // State transition logic
    assign next_state = (
        (state == 4'b0001) ? (in ? 4'b0010 : 4'b0001) :
        (state == 4'b0010) ? (in ? 4'b0010 : 4'b0100) :
        (state == 4'b0100) ? (in ? 4'b1000 : 4'b0001) :
        (state == 4'b1000) ? (in ? 4'b0010 : 4'b0100) :
        4'bxxxx
    );

endmodule