module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize to unknown to match waveform initial 'x' states
initial begin
    p = 1'bx;
    q = 1'bx;
end

always @(posedge clock) begin
    if (q === 1'bx) begin
        // At first posedge, set p=0 when q unknown
        p <= 1'b0;
    end else if (q == 1'b0) begin
        p <= a;
    end else begin // q == 1'b1
        if (a == 1'b1)
            p <= 1'b1;
        else
            p <= p; // hold previous p value
    end
end

always @(negedge clock) begin
    q <= p;
end

endmodule