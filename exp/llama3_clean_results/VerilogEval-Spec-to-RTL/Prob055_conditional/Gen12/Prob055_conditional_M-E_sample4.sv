module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

wire a_smaller_than_b = (a < b);
wire a_smaller_than_c = (a < c);
wire a_smaller_than_d = (a < d);
wire b_smaller_than_c = (b < c);
wire b_smaller_than_d = (b < d);
wire c_smaller_than_d = (c < d);

wire [1:0] select;
assign select = (a_smaller_than_b && a_smaller_than_c && a_smaller_than_d) ? 2'b00 :
                (b_smaller_than_a && b_smaller_than_c && b_smaller_than_d) ? 2'b01 :
                (c_smaller_than_a && c_smaller_than_b && c_smaller_than_d) ? 2'b10 :
                2'b11;

assign min = (select == 2'b00) ? a :
             (select == 2'b01) ? b :
             (select == 2'b10) ? c :
             d;

endmodule