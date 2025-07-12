module TopModule(
    input wire d,
    input wire ena,
    output reg q
);
    always @(ena or d) begin
        if (ena)
            q <= d;
        // else do nothing; latch holds previous value
    end
endmodule