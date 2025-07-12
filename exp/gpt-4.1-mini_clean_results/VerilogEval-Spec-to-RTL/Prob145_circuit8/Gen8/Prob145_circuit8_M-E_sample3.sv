module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

reg stateA;

// Initialize p and q to unknown to match waveform initial unknowns
initial begin
    p = 1'bx;
    q = 1'bx;
    stateA = 1'bx;
end

// Sample input 'a' into internal register stateA at posedge clock
always @(posedge clock) begin
    stateA <= a;
end

// Assign p to current stateA combinationally after posedge clock sample
always @(posedge clock or negedge clock) begin
    if (clock) // posedge clock
        p <= stateA;
end

// Update q at negedge clock with hold behavior:
// if p is 1, set q to 1; if p is 0, set q to 0; else retain q
always @(negedge clock) begin
    if (p === 1'b1)
        q <= 1'b1;
    else if (p === 1'b0)
        q <= 1'b0;
    // else q keeps its value (including unknown)
end

endmodule