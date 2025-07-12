module TopModule(
    input  d,
    input  ena,
    output reg q
);

    always @(d or ena) begin
        if (ena)
            q = d;  // latch is transparent when ena is high
        // else no assignment -> latch holds previous value
    end

endmodule