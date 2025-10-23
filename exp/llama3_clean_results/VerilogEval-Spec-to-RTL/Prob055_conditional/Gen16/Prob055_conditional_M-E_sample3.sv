module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

reg [7:0] a1, b1, c1, d1;
reg [7:0] a2, b2, c2, d2;

// Stage 1: Compare and swap
always @(*) begin
    a1 = (a < b)? a : b;
    b1 = (a < b)? b : a;
    c1 = (c < d)? c : d;
    d1 = (c < d)? d : c;
end

// Stage 2: Compare and swap
always @(*) begin
    a2 = (a1 < c1)? a1 : c1;
    b2 = (a1 < c1)? c1 : a1;
    c2 = (b1 < d1)? b1 : d1;
    d2 = (b1 < d1)? d1 : b1;
end

// Stage 3: Compare and swap
always @(*) begin
    min = (a2 < b2)? a2 : b2;
end

endmodule