module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

// State encoding: 0 - OFF, 1 - ON
reg [1:0] state, next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 2'b00; // Reset to OFF state (out=0)
    end else begin
        state <= next_state;
    end
end

// Next-state logic using a LUT
always @(*) begin
    case ({state, j, k})
        3'b000, 3'b001: next_state = 2'b00; // OFF state
        3'b010: next_state = 2'b01; // Transition to ON state
        3'b011, 3'b100: next_state = 2'b01; // ON state
        3'b101: next_state = 2'b00; // Transition to OFF state
        default: next_state = 2'b00; // Default to OFF state
    endcase
end

// Output logic directly from state
assign out = state[0];

endmodule