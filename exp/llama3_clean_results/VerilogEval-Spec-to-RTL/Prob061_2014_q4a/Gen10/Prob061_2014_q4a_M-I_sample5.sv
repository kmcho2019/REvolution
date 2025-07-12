// TopModule: A single stage of an n-bit shift register
module TopModule(
    input  clk,  // Clock signal
    input  w,    // Input from the previous stage
    input  R,    // Value to load
    input  E,    // Enable shift
    input  L,    // Load signal
    output reg Q  // Output of this stage
);

// Intermediate variable to hold the next state of Q
reg Q_next;

// Combinational logic to determine the next state of Q
always @(*) begin
    // Priority to load operation
    if (L) begin
        Q_next = R;
    end else if (E) begin
        // Shift operation
        Q_next = w;
    end else begin
        // Hold the current state if no operation is enabled
        Q_next = Q;
    end
end

// Sequential logic to update Q on the positive edge of the clock
always @(posedge clk) begin
    Q <= Q_next;
end

endmodule