module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    always @(posedge clock) begin
        // Update p: set to 1 if 'a' is 1 and q is 0 (trigger event)
        if (a && !q)
            p <= 1'b1;
        else
            p <= 1'b0;

        // Update q: latch p's assertion, hold once set
        if (p || q)
            q <= 1'b1;
        else
            q <= 1'b0;
    end

endmodule