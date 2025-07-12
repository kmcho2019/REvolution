module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    always @(*) begin
        // First find min of a and b
        min = (a < b) ? a : b;
        // Then find min of c and d
        min = (min < ((c < d) ? c : d)) ? min : ((c < d) ? c : d);
    end

endmodule