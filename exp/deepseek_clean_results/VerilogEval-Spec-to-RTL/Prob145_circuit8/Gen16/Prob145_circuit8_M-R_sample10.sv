module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// p update logic: follows 'a' when q is 0
always @(posedge clock) begin
    if (~q) begin
        p <= a;
    end
end

// q update logic: becomes 1 after p was 1, resets when a is 1
always @(posedge clock) begin
    if (a) begin
        q <= 0;
    end else if (p) begin
        q <= 1;
    end
end

initial begin
    p = 0;
    q = 0;
end

endmodule