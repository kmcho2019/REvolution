module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Internal register to hold previous p value for q update
reg p_next;

initial begin
    p = 1'b0;
    q = 1'b0;
    p_next = 1'b0;
end

always @(posedge clock) begin
    // Update p based on a and current q and previous p
    // From waveform, p sets to 1 if a=1 or holds previous p when q=1 and a=0
    if (q == 1'b0)
        p_next <= a;
    else
        p_next <= p | a;

    q <= p;  // q latches previous p
    p <= p_next; // update p
end

endmodule