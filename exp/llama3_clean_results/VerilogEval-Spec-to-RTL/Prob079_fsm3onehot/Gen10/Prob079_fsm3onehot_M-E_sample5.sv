module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // Decoder for one-hot encoded states
    wire [3:0] state_a, state_b, state_c, state_d;
    assign state_a = (state == A) ? 1'b1 : 1'b0;
    assign state_b = (state == B) ? 1'b1 : 1'b0;
    assign state_c = (state == C) ? 1'b1 : 1'b0;
    assign state_d = (state == D) ? 1'b1 : 1'b0;

    // Multiplexers for next state selection
    wire [3:0] next_state_a, next_state_b, next_state_c, next_state_d;
    assign next_state_a = (in) ? B : A;
    assign next_state_b = (in) ? B : C;
    assign next_state_c = (in) ? D : A;
    assign next_state_d = (in) ? B : C;

    // Select next state based on current state
    assign next_state = (state_a) ? next_state_a :
                         (state_b) ? next_state_b :
                         (state_c) ? next_state_c :
                         (state_d) ? next_state_d : 4'bxxxx;

    // Output logic
    assign out = (state == D);

endmodule