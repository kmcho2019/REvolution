module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    p <= clock & a;  // p is high when clock is high and a is high
    p_prev <= p;     // Remember previous p state
end

always @(negedge clock) begin
    if (~a) begin    // Clear q during clock low when a is low
        q <= 1'b0;
    end
    else if (p_prev) begin  // Set q if p was high last cycle
        q <= 1'b1;
    end
end

endmodule