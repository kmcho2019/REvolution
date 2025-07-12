module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // Directly implementing state transitions based on the one-hot encoding
    assign next_state = (state == A)? (in? B : A) :
                        (state == B)? (in? B : C) :
                        (state == C)? (in? D : A) :
                        (state == D)? (in? B : C) : 4'bxxxx;

    // Output logic remains the same, as it directly checks the state
    assign out = (state == D)? 1'b1 : 1'b0;

endmodule