module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

always @(*) begin
    reg [7:0] temp_min1, temp_min2;
    temp_min1 = (a < b)? a : b;
    temp_min2 = (c < d)? c : d;
    min = (temp_min1 < temp_min2)? temp_min1 : temp_min2;
end

endmodule