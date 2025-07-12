module TopModule(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

    wire [1:0] sel;
    assign sel = c[1:0];

    assign q = (c < 4'd4) ? (
        (sel == 2'd0) ? b :
        (sel == 2'd1) ? e :
        (sel == 2'd2) ? a :
        (sel == 2'd3) ? d : 4'd15
    ) : 4'd15;

endmodule