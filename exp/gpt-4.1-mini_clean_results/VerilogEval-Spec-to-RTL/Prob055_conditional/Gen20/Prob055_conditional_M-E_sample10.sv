module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);
    always @(*) begin
        reg [7:0] min_val;
        min_val = a;
        if (b < min_val) min_val = b;
        if (c < min_val) min_val = c;
        if (d < min_val) min_val = d;
        min = min_val;
    end
endmodule