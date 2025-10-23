module TopModule (
    input  wire d,
    input  wire ena,
    output reg  q
);

    always @(d or ena) begin
        if (ena)
            q = d;    // latch is transparent when ena is high
        // else q holds the previous value (no assignment)
    end

endmodule