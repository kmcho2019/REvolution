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

    assign next_state = 
        (state == A)? ((in == 1'b0)? A : B) :
        (state == B)? ((in == 1'b0)? C : B) :
        (state == C)? ((in == 1'b0)? A : D) :
        (state == D)? ((in == 1'b0)? C : B) : 4'bxxxx;

    assign out = 
        (state == A)? 1'b0 :
        (state == B)? 1'b0 :
        (state == C)? 1'b0 :
        (state == D)? 1'b1 : 1'b0;

endmodule