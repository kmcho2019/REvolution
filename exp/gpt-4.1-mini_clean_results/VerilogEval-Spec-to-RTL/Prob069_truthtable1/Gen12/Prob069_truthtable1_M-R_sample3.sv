module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output reg  f
);

    always @(*) begin
        if (x3)
            f = x1;
        else
            f = x2;
    end

endmodule