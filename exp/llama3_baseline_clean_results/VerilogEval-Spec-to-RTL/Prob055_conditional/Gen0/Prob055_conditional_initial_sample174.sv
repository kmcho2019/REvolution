module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    wire [7:0] temp1;
    wire [7:0] temp2;

    assign temp1 = (a < b) ? a : b;
    assign temp2 = (c < d) ? c : d;
    assign min    = (temp1 < temp2) ? temp1 : temp2;

endmodule