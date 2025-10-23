module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    reg p_next;

    // Asynchronous reset to initialize state
    initial begin
        p = 1'b0;
        q = 1'b0;
        p_next = 1'b0;
    end

    // On positive edge of clock: compute next p state using input 'a' and current p,q
    always @(posedge clock) begin
        p_next <= a | (p & ~q);
        p <= p_next;
    end

    // On negative edge of clock: update q from current p
    always @(negedge clock) begin
        q <= p;
    end

endmodule