module StateA(
    input in,
    output [3:0] next_state,
    output out
);
    localparam A = 4'b0001;
    localparam B = 4'b0010;

    assign next_state = (in)? B : A;
    assign out = 1'b0;
endmodule

module StateB(
    input in,
    output [3:0] next_state,
    output out
);
    localparam B = 4'b0010;
    localparam C = 4'b0100;

    assign next_state = (in)? B : C;
    assign out = 1'b0;
endmodule

module StateC(
    input in,
    output [3:0] next_state,
    output out
);
    localparam A = 4'b0001;
    localparam D = 4'b1000;

    assign next_state = (in)? D : A;
    assign out = 1'b0;
endmodule

module StateD(
    input in,
    output [3:0] next_state,
    output out
);
    localparam B = 4'b0010;
    localparam C = 4'b0100;

    assign next_state = (in)? B : C;
    assign out = 1'b1;
endmodule

module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);
    wire [3:0] next_state_A;
    wire [3:0] next_state_B;
    wire [3:0] next_state_C;
    wire [3:0] next_state_D;

    wire out_A;
    wire out_B;
    wire out_C;
    wire out_D;

    StateA stateA(in, next_state_A, out_A);
    StateB stateB(in, next_state_B, out_B);
    StateC stateC(in, next_state_C, out_C);
    StateD stateD(in, next_state_D, out_D);

    assign next_state = (state == 4'b0001)? next_state_A :
                        (state == 4'b0010)? next_state_B :
                        (state == 4'b0100)? next_state_C :
                        (state == 4'b1000)? next_state_D : 4'bxxxx;

    assign out = (state == 4'b0001)? out_A :
                 (state == 4'b0010)? out_B :
                 (state == 4'b0100)? out_C :
                 (state == 4'b1000)? out_D : 1'b0;
endmodule