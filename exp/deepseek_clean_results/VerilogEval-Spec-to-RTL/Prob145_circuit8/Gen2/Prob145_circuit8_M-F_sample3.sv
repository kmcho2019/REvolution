module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;
reg prev_p;

always @(posedge clock) begin
    // Update p: high if current and previous a were both 1
    p <= a & prev_a;
    
    // Update q: high if current and previous p were both 1
    q <= p & prev_p;
    
    // Store previous values
    prev_a <= a;
    prev_p <= p;
end

// Reset logic - clears state when a=1 during non-clock edges
always @(negedge clock) begin
    if (a) begin
        p <= 0;
        q <= 0;
        prev_a <= 0;
        prev_p <= 0;
    end
end

endmodule