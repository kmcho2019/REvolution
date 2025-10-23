module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_next;
reg q_next;
reg p_prev;

always @(*) begin
    // p follows 'a' when clock is high, holds otherwise
    if (clock) begin
        p_next = a;
    end else begin
        p_next = p;
    end
end

always @(negedge clock) begin
    // q remembers if p was high at previous posedge
    q_next = p_prev;
end

always @(posedge clock) begin
    // Update p at positive edge
    p <= p_next;
    // Store p's value for q
    p_prev <= p;
    // Update q at positive edge
    q <= q_next;
end

initial begin
    p = 1'b0;
    q = 1'b0;
    p_next = 1'b0;
    q_next = 1'b0;
    p_prev = 1'b0;
end

endmodule