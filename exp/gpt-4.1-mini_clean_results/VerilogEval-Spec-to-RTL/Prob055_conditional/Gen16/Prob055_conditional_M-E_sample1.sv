module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);
    always @* begin
        // Compare a and b
        min = (a < b) ? a : b;
        // Compare c and d, then compare to current min
        min = ((c < d) ? c : d) < min ? ((c < d) ? c : d) : min;
    end
endmodule