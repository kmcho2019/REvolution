module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg q_set;  // Internal flag to track if p was high

// p is high only when a is high during clock high phase
always @(posedge clock) begin
    p <= a & clock;
end

// q_set tracks if p was ever high (synchronous)
always @(posedge clock) begin
    q_set <= q_set | p;
end

// q is set when p was high, cleared asynchronously
always @(posedge clock or posedge (a & ~clock)) begin
    if (a & ~clock) begin
        q <= 1'b0;
        q_set <= 1'b0;  // Also clear the set flag
    end
    else begin
        q <= q_set;
    end
end

endmodule