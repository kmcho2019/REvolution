module TopModule(
    input d,
    input ena,
    output reg q
);

    always @(ena or q) begin
        if (ena)
            q <= d; // latch transparent when ena high
        else
            q <= q; // retain previous value (latch holds)
    end

endmodule