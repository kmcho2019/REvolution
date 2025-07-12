module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

initial begin
    p = 1'bx;
    q = 1'bx;
end

// On rising clock edge, p sets or holds to 1 if a=1 or p=1, else resets to 0
always @(posedge clock) begin
    if (p === 1'bx)
        p <= 1'b0; // Initialize p at first clock posedge if unknown
    else
        p <= a | p;
end

// On falling clock edge, q captures the value of p (delayed by one half clock cycle)
always @(negedge clock) begin
    if (q === 1'bx)
        q <= 1'b0; // Initialize q at first negedge if unknown
    else
        q <= p;
end

endmodule