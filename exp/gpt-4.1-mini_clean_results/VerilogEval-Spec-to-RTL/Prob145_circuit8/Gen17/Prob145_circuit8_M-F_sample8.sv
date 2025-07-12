module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize outputs to unknown to match initial 'x' in waveform
initial begin
    p = 1'bx;
    q = 1'bx;
end

// p updated at posedge clock: p = a & ~q
always @(posedge clock) begin
    if (q === 1'bx) begin
        // On first active clock edge, if q unknown, set p to 0
        p <= 1'b0;
    end else begin
        p <= a & ~q;
    end
end

// q updated at negedge clock: q = p | q
always @(negedge clock) begin
    if (q === 1'bx) begin
        // On first negedge clock when q unknown, initialize q to 0
        q <= 1'b0;
    end else begin
        q <= p | q;
    end
end

endmodule