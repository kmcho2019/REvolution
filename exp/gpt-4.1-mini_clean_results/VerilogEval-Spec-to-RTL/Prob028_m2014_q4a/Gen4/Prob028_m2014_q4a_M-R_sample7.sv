module TopModule(
    input  d,
    input  ena,
    output reg q
);

    always @(d or ena) begin
        if (ena)
            q <= d;  // latch transparent when ena is high
        // else q retains its value (latch behavior)
    end

endmodule