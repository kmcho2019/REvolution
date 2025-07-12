module TopModule(
    input d,
    input ena,
    output reg q
);

    always @(ena or d) begin
        if (ena)
            q = d;  // latch transparent when ena is high
        // else q holds its value (no assignment)
    end

endmodule