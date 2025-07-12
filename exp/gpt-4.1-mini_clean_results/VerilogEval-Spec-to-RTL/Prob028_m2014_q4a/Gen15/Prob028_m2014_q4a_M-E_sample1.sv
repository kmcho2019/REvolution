module TopModule (
    input  d,
    input  ena,
    output reg q
);

    initial q = 1'b0;

    always @(*) begin
        if (ena)
            q <= d;
        // else q retains previous value (latch behavior)
    end

endmodule