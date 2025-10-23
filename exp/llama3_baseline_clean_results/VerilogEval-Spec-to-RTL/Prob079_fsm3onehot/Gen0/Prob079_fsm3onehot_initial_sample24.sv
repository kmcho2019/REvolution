module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // State transition logic
    assign next_state = 
        ({state[0] && !in}, {state[0] && in}, {state[1] && !in}, {state[1] && in}) ? 4'b0010 : // A -> B
        ({state[1] && !in}, {state[1] && in}, {state[2] && !in}, {state[2] && in}) ? 4'b0100 : // B -> C
        ({state[2] && !in}, {state[2] && in}, {state[3] && !in}, {state[3] && in}) ? 4'b0001 : // C -> A
        ({state[3] && !in}, {state[3] && in}, {state[0] && !in}, {state[0] && in}) ? 4'b0100 : // D -> C
        ({state[3] && in}, {state[3] && in}, {state[0] && in}, {state[0] && in}) ? 4'b0010 : // D -> B
        ({state[0] && !in}, {state[0] && in}, {state[0] && !in}, {state[0] && in}) ? 4'b0001 : // A -> A
        ({state[1] && in}, {state[1] && in}, {state[1] && in}, {state[1] && in}) ? 4'b0010 : // B -> B
        ({state[2] && in}, {state[2] && in}, {state[2] && in}, {state[2] && in}) ? 4'b1000 : // C -> D
        4'b0000; // Default

    // Output logic
    assign out = state[3];

endmodule