module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

reg [1:0] min_index;

always @(*) begin
    if (a <= b && a <= c && a <= d) begin
        min_index = 2'b00;
        min = a;
    end else if (b <= a && b <= c && b <= d) begin
        min_index = 2'b01;
        min = b;
    end else if (c <= a && c <= b && c <= d) begin
        min_index = 2'b10;
        min = c;
    end else begin
        min_index = 2'b11;
        min = d;
    end
end

endmodule