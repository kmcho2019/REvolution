module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

always @(*) begin
    min = (a <= b)? (a <= c && a <= d)? a : ((b <= c && b <= d)? b : (c <= d? c : d)) : 
                       (b <= c && b <= d)? b : ((a <= c && a <= d)? a : (c <= d? c : d));
end

endmodule