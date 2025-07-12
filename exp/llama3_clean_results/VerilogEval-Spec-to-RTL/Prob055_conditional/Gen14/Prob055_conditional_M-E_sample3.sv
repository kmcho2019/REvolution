module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Stage 1: Compare and swap pairs
    wire [7:0] a_b;
    wire [7:0] b_b;
    wire [7:0] c_d;
    wire [7:0] d_d;

    assign a_b = (a < b)? a : b;
    assign b_b = (a < b)? b : a;
    assign c_d = (c < d)? c : d;
    assign d_d = (c < d)? d : c;

    // Stage 2: Compare and swap winners
    wire [7:0] a_win;
    wire [7:0] b_win;

    assign a_win = (a_b < c_d)? a_b : c_d;
    assign b_win = (a_b < c_d)? c_d : a_b;

    // Stage 3: Compare and swap final winners
    assign min = (a_win < b_win)? a_win : b_win;

endmodule