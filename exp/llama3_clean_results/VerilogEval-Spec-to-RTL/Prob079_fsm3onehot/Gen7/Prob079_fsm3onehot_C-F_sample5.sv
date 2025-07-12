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

    // Define LUTs for state transition logic
    wire [3:0] next_state_in0;
    wire [3:0] next_state_in1;

    // LUT for in=0
    assign next_state_in0 = (state == A)? A :
                             (state == B)? C :
                             (state == C)? A :
                             (state == D)? C;

    // LUT for in=1
    assign next_state_in1 = (state == A)? B :
                             (state == B)? B :
                             (state == C)? D :
                             (state == D)? B;

    // Select next state based on input condition
    assign next_state = (in)? next_state_in1 : next_state_in0;

    // Output logic
    assign out = (state == D)? 1'b1 : 1'b0;

endmodule