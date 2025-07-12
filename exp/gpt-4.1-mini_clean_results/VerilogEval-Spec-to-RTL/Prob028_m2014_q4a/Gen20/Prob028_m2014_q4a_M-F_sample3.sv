module TopModule (
    input wire d,
    input wire ena,
    output reg q
);
    always @(ena or d) begin
        if (ena)
            q = d;  // latch transparent when enabled
        // no else branch: latch holds previous value implicitly
    end
endmodule