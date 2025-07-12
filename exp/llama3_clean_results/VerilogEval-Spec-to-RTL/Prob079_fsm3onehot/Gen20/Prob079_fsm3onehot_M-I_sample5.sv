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

    // State transition logic
    assign next_state = (state == A)?  (in? B : A) :
                        (state == B)?  (in? B : C) :
                        (state == C)?  (in? D : A) :
                        (state == D)?  (in? B : C) : 4'bxxxx;

    // Alternatively, for potential simplification, directly implement state transitions
    // assign next_state = ({4{~in}} & (state == A))? A :
    //                     ({4{~in}} & (state == B))? C :
    //                     ({4{~in}} & (state == C))? A :
    //                     ({4{~in}} & (state == D))? C :
    //                     ({4{ in}} & (state == A))? B :
    //                     ({4{ in}} & (state == B))? B :
    //                     ({4{ in}} & (state == C))? D :
    //                     ({4{ in}} & (state == D))? B : 4'bxxxx;

    // Output logic
    assign out = (state == D)? 1'b1 : 1'b0;

endmodule