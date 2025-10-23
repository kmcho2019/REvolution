module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state; // 2-bit register for current state
reg [1:0] next_state; // 2-bit register for next state

// Lookup table for state transitions
always_comb begin
    case ({state, j, k})
        3'b000: next_state = 2'b00; // OFF state, j=0, k=0
        3'b001: next_state = 2'b00; // OFF state, j=0, k=1
        3'b010: next_state = 2'b01; // OFF state, j=1, k=0
        3'b011: next_state = 2'b01; // OFF state, j=1, k=1
        3'b100: next_state = 2'b01; // ON state, j=0, k=0
        3'b101: next_state = 2'b01; // ON state, j=0, k=1
        3'b110: next_state = 2'b00; // ON state, j=1, k=0
        3'b111: next_state = 2'b00; // ON state, j=1, k=1
        default: next_state = 2'b00; // Default to OFF state
    endcase
end

// State register with synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

// Output logic
assign out = state[1]; // Output is high when state is ON

endmodule