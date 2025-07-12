module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    wire a_smaller_than_b;
    wire a_smaller_than_c;
    wire a_smaller_than_d;
    wire b_smaller_than_c;
    wire b_smaller_than_d;
    wire c_smaller_than_d;

    assign a_smaller_than_b = (a < b)? 1'b1 : 1'b0;
    assign a_smaller_than_c = (a < c)? 1'b1 : 1'b0;
    assign a_smaller_than_d = (a < d)? 1'b1 : 1'b0;
    assign b_smaller_than_c = (b < c)? 1'b1 : 1'b0;
    assign b_smaller_than_d = (b < d)? 1'b1 : 1'b0;
    assign c_smaller_than_d = (c < d)? 1'b1 : 1'b0;

    assign min = (a_smaller_than_b && a_smaller_than_c && a_smaller_than_d)? a :
                 (b_smaller_than_c && b_smaller_than_d && (~a_smaller_than_b))? b :
                 (c_smaller_than_d && (~a_smaller_than_c) && (~b_smaller_than_c))? c :
                 d;

endmodule