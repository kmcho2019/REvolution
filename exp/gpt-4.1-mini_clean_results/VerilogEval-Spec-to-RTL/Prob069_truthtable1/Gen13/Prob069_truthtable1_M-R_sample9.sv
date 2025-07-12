module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output reg  f
);

    always @* begin
        f = (x2 & ~x3) | (x1 & x3);
    end

endmodule