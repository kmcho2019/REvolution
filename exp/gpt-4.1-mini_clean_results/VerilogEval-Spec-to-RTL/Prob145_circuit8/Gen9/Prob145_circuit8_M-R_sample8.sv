module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize p and q to unknown to reflect waveform start at 'x'
initial begin
    p = 1'bx;
    q = 1'bx;
end

always @(posedge clock or negedge clock) begin
    if (clock) begin
        // Rising edge: update p according to a and q
        if (a == 1'b1)
            p <= 1'b1;
        else if ((a == 1'b0) && (q == 1'b1))
            p <= 1'b0;
        else
            p <= p; // Hold
    end else begin
        // Falling edge: update q with current p
        q <= p;
    end
end

endmodule