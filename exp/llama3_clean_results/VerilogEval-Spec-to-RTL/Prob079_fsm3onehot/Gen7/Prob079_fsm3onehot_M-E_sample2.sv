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

    // State blocks
    wire [3:0] next_state_A;
    wire [3:0] next_state_B;
    wire [3:0] next_state_C;
    wire [3:0] next_state_D;
    wire out_A;
    wire out_B;
    wire out_C;
    wire out_D;

    // State A logic
    assign next_state_A = in ? B : A;
    assign out_A = 1'b0;

    // State B logic
    assign next_state_B = in ? B : C;
    assign out_B = 1'b0;

    // State C logic
    assign next_state_C = in ? D : A;
    assign out_C = 1'b0;

    // State D logic
    assign next_state_D = in ? B : C;
    assign out_D = 1'b1;

    // Multiplexers for next state and output
    assign next_state = (state == A) ? next_state_A :
                        (state == B) ? next_state_B :
                        (state == C) ? next_state_C :
                        (state == D) ? next_state_D : 4'bxxxx;

    assign out = (state == A) ? out_A :
                 (state == B) ? out_B :
                 (state == C) ? out_C :
                 (state == D) ? out_D : 1'b0;

endmodule