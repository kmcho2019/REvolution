module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_next;

always @(posedge clock) begin
    p <= p_next;
    q <= p;  // q gets previous cycle's p value
end

always @(*) begin
    if (clock) begin
        p_next = a;  // p_next follows 'a' while clock is high
    end else begin
        p_next = 0;  // reset when clock is low
    end
end

endmodule