module TopModule(
    input wire clock,
    input wire a,
    output reg p,
    output reg q
);

// Register to hold previous clock value to detect falling edge
reg clock_d;
// Flag to hold reset request for q on next posedge clock
reg q_reset_req;

always @(posedge clock) begin
    // Sample previous clock level
    clock_d <= clock;

    // p is assigned 'a' sampled at clock rising edge
    p <= a;

    // If reset requested for q, clear q
    if (q_reset_req)
        q <= 1'b0;
    else
        // Set q if p is high; latch behavior q <= q | p
        q <= q | p;

    // Clear reset request after applying it
    if (q_reset_req)
        q_reset_req <= 1'b0;
end

// Combinational block to detect falling edge of clock and 'a' high,
// and set reset request for q
always @(*) begin
    // Detect falling edge of clock: clock_d=1 and clock=0, and a=1 at that time
    if ((clock_d == 1'b1) && (clock == 1'b0) && (a == 1'b1))
        q_reset_req = 1'b1;
    else
        // Do not set reset request otherwise
        // Keep previous reset request cleared after posedge clock handled it
        q_reset_req = q_reset_req;
end

endmodule