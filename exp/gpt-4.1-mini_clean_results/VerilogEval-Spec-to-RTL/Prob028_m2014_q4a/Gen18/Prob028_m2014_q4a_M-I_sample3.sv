module TopModule (
    input  wire d,
    input  wire ena,
    output reg  q
);

    // D latch inference: latch transparent when ena=1, holds q otherwise.
    always @(d or ena) begin
        if (ena)
            q = d;
        // No else branch - incomplete assignment infers latch hold behavior.
    end

endmodule