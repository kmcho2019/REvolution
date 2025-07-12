module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] out
);

    always @(*) begin
        // If sel is 1, output should be b, otherwise a
        out = sel? b : a;
    end

endmodule