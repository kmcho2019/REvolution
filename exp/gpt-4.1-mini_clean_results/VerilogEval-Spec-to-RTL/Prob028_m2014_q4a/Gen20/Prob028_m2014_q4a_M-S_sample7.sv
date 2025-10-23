module TopModule(
    input  d,
    input  ena,
    output reg q
);

    always @(ena) begin
        if (ena)
            q <= d;  // latch transparent when ena=1
        // else q holds previous value
    end

endmodule