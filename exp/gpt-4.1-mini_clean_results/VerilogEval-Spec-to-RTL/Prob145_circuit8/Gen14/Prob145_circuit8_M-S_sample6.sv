module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    reg p_next;

    always @(posedge clock) begin
        p_next = (a && !q);
        p <= p_next;
        q <= q || p_next;
    end

endmodule