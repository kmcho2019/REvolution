module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 0;
    q = 0;
end

always @(posedge clock) begin
    // Store previous p before update for q
    reg prev_p;
    prev_p = p;

    // Update p based on a, previous p, and previous q
    p <= a | (p & q);

    // Update q with previous value of p (prev_p)
    q <= prev_p;
end

endmodule