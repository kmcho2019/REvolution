module TopModule(
    input wire clock,
    input wire a,
    output reg p,
    output reg q
);

// Initialize outputs to unknown to match waveform at start
initial begin
    p = 1'bx;
    q = 1'bx;
end

// On rising edge of clock, update p to input a
always @(posedge clock) begin
    p <= a;
    // q holds its previous value at posedge
end

// On falling edge of clock, update q to the current p
always @(negedge clock) begin
    q <= p;
    // p holds its previous value at negedge
end

endmodule