module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    reg p_next, q_next;

    always @(posedge clock) begin
        p <= a | q;
        q <= p;
    end

endmodule