module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

    wire p_next = clock & a;
    wire q_next = p;

    always @(posedge clock) begin
        p <= p_next;
    end

    always @(negedge clock) begin
        q <= q_next;
    end

endmodule