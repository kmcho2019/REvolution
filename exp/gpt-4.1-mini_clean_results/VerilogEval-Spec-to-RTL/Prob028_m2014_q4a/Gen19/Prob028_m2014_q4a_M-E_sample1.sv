module TopModule (
    input wire d,
    input wire ena,
    output reg q
);
    always @(ena or d) begin
        if (ena)
            q <= d;    // latch transparent when enabled
        else
            q <= q;    // latch holds value when not enabled
    end
endmodule