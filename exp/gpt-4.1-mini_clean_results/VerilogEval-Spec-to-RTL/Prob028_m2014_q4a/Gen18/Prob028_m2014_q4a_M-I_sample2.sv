module TopModule (
    input  wire d,
    input  wire ena,
    output reg  q
);

    // Level-sensitive D latch: assign q = d when ena=1; else hold q by not assigning it
    always @(d or ena) begin
        if (ena)
            q = d;
        // else no assignment to q, latch inferred
    end

endmodule