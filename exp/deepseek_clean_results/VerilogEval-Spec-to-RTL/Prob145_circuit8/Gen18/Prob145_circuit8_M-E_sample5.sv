module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// p acts as a transparent latch enabled when clock is high
always @(*) begin
    if (clock) begin
        p = a;
    end
end

// q acts as a negative-edge triggered flip-flop sampling p
always @(negedge clock) begin
    q <= p;
end

initial begin
    p = 1'b0;
    q = 1'b0;
end

endmodule