module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;  // Stores previous value of a for edge detection

// Rising edge behavior - generate p pulses
always @(posedge clock) begin
    a_prev <= a;
    if (a && !a_prev) begin
        p <= 1;
    end else begin
        p <= 0;
    end
end

// Falling edge behavior - capture p into q
always @(negedge clock) begin
    q <= p;
end

initial begin
    p = 0;
    q = 0;
    a_prev = 0;
end

endmodule