module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Next state logic
    assign next_state = (
        // If current state is A
        (state == 4'b0001) ? (in == 0 ? 4'b0001 : 4'b0010) :
        // If current state is B
        (state == 4'b0010) ? (in == 0 ? 4'b0100 : 4'b0010) :
        // If current state is C
        (state == 4'b0100) ? (in == 0 ? 4'b0001 : 4'b1000) :
        // If current state is D
        (state == 4'b1000) ? (in == 0 ? 4'b0100 : 4'b0010) :
        4'b0000  // Default value
    );

    // Output logic
    assign out = (state == 4'b1000) ? 1'b1 : 1'b0;

endmodule