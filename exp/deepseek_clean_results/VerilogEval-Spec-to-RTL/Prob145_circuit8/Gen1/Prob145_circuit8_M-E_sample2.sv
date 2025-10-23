module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg state;

localparam IDLE = 1'b0;
localparam ACTIVE = 1'b1;

always @(posedge clock) begin
    state <= ACTIVE;
    p <= a;  // p follows a only when clock is high
end

always @(negedge clock) begin
    state <= IDLE;
    q <= p;  // capture p's value on negative edge
    p <= 1'b0;  // reset p when clock goes low
end

// Initialize outputs
initial begin
    state = IDLE;
    p = 1'b0;
    q = 1'b0;
end

endmodule