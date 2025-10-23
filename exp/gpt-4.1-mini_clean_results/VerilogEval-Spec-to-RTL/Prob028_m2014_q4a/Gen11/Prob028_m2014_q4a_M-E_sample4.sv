module TopModule(
    input d,
    input ena,
    output reg q
);
    always @(ena or d) begin
        if (ena)
            q <= d;
        else
            q <= q; // hold previous value to infer latch
    end
endmodule