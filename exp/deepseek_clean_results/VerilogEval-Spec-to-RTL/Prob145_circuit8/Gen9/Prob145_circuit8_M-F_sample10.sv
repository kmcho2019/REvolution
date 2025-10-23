module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

// p toggles when a is high at clock edge
always @(posedge clock) begin
    if (a) p <= ~p;
end

// q follows p with 1-cycle delay and async clear
always @(posedge clock or posedge (a & ~clock)) begin
    if (a & ~clock) begin
        q <= 1'b0;
    end else begin
        q <= p_prev;
    end
end

// Store previous p value
always @(posedge clock) begin
    p_prev <= p;
end

endmodule