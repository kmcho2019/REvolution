module TopModule (
    input wire d,
    input wire ena,
    output reg q
);
    always @(d or ena) begin
        if (ena)
            q = d;    // latch transparent when enabled
        // else q not assigned => latch holds previous value
    end
endmodule