module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    always @(*) begin
        // First compare a and b
        // Then compare c and d
        // Then compare the two minimums
        min = (a < b) ? ((c < d) ? ((a < c) ? a : c) : ((a < d) ? a : d))
                      : ((c < d) ? ((b < c) ? b : c) : ((b < d) ? b : d));
    end

endmodule