module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State transition logic using direct logic equations
    assign next_state = (
        (state == 4'b0001) ? {3'b000, ~in} : 
        (state == 4'b0010) ? {2'b01, in} : 
        (state == 4'b0100) ? {1'b1, ~in, 2'b00} : 
        (state == 4'b1000) ? {2'b01, in} : 
        4'bxxxx
    );

    // Output logic directly based on the state
    assign out = state[3]; // D state (4'b1000) has the output as 1

endmodule