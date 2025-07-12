module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // 2-bit state variable (only 2 states, but using 2-bit for LUT indexing)
reg [1:0] next_state; // Next state
reg [1:0] lut[2]; // Lookup table

// Initialize LUT values
initial begin
    lut[0] = 2'b10; // State A: next_state = B, out = 0
    lut[1] = 2'b11; // State B: next_state = B, out = 1 when in = 1; next_state = A, out = 0 when in = 0
end

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 2'b01; // Reset to state B
    end else begin
        // Use LUT to determine next state and output
        if (in) begin
            next_state = lut[state][1];
        end else begin
            next_state = lut[state][0];
        end
        state <= next_state;
    end
end

always @(*) begin
    // Determine output based on current state
    if (state == 2'b01) begin // State B
        out = 1'b1;
    end else if (state == 2'b10) begin // State A
        out = 1'b0;
    end
end

endmodule