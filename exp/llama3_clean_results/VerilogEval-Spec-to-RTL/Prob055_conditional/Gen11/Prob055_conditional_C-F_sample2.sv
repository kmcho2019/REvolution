module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

always @(*) begin
    // Compare pairs of inputs and select the smaller value
    reg [7:0] min_ab = (a < b)? a : b;
    reg [7:0] min_cd = (c < d)? c : d;

    // Compare the smaller values and select the overall minimum
    min = (min_ab < min_cd)? min_ab : min_cd;
end

endmodule