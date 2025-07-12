module TopModule(
    input wire clock,
    input wire a,
    output reg p,
    output reg q
);

reg a_d;             // Delayed 'a' sampled at last clock rising edge
reg async_reset_req; // Flag set asynchronously when clock=0 and a=1

// Detect asynchronously when clock=0 and a=1 and set reset request
always @(*) begin
    // If clock is low and a is high, request q reset at next clock edge
    if (~clock && a)
        async_reset_req = 1'b1;
    else
        async_reset_req = 1'b0;
end

always @(posedge clock) begin
    // Update delayed 'a'
    a_d <= a;

    // 'p' is high when 'a' rises from 0 to 1 at clock edge
    p <= (~a_d) & a;

    // 'q' set when 'p' is high; reset when async_reset_req is set
    if (async_reset_req)
        q <= 1'b0;
    else
        q <= q | p;
end

endmodule