module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    wire next_p;
    wire next_q;

    assign next_p = a | (p & ~q);
    assign next_q = p;

    always @(posedge clock) begin
        p <= next_p;
        q <= next_q;
    end

endmodule