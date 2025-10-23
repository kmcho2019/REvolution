module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);

    always @(*) begin
        // Directly compare all inputs to find the minimum
        min = (a < b && a < c && a < d)? a :
              (b < a && b < c && b < d)? b :
              (c < a && c < b && c < d)? c : d;
    end

endmodule