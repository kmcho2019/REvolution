module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize p and q to unknown as per waveform initial states
initial begin
    p = 1'bx;
    q = 1'bx;
end

always @(posedge clock) begin
    q <= p;           // q takes previous p value
    if (a == 1'b1)
        p <= 1'b1;    // p is set when a is 1
    else
        p <= 1'b0;    // otherwise p is 0
end

endmodule