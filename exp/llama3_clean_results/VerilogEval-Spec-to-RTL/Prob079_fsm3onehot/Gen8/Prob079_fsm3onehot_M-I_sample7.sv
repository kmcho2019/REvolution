module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    wire [3:0] A = 4'b0001;
    wire [3:0] B = 4'b0010;
    wire [3:0] C = 4'b0100;
    wire [3:0] D = 4'b1000;

    // State transition logic leveraging one-hot encoding
    assign next_state[0] = (~in && state[0]) || (~in && state[2]) || (~in && state[3]); // Next state bit for A (LSB)
    assign next_state[1] = (in && state[0]) || (in && state[1]) || (in && state[3]); // Next state bit for B
    assign next_state[2] = (~in && state[1]) || (in && state[2]); // Next state bit for C
    assign next_state[3] = (in && state[2]); // Next state bit for D (MSB)

    // Output logic remains straightforward
    assign out = state[3]; // Output is high only when in state D

endmodule