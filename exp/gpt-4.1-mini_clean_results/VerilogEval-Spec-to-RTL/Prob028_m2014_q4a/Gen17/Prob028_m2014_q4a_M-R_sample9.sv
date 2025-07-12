module TopModule (
    input  wire d,
    input  wire ena,
    output reg  q
);

    // Implement latch behavior with continuous assignment style inside an always block sensitive to changes in d, ena, or q itself
    always @(*) begin
        if (ena)
            q = d;
        else
            q = q;  // hold previous value (feedback)
    end

endmodule