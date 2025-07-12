module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    wire [1:0] min_index;
    assign min_index = (a <= b && a <= c && a <= d)? 2'b00 :
                       (b <= a && b <= c && b <= d)? 2'b01 :
                       (c <= a && c <= b && c <= d)? 2'b10 :
                       2'b11;

    assign min = (min_index == 2'b00)? a :
                 (min_index == 2'b01)? b :
                 (min_index == 2'b10)? c :
                 d;

endmodule