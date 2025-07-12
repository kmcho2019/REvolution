module TopModule(
    input  d,
    input  ena,
    output reg q
);

    always @(d or ena) begin
        if (ena)
            q <= d;  // latch transparent when ena=1
        // else: no update, q holds its value (latch inferred)
    end

endmodule