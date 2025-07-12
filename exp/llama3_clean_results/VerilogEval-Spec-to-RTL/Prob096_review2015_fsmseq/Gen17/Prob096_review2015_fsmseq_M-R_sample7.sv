module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // 3-bit state encoding for 5 states (including the final state)

// Initialize the FSM to the IDLE state
initial state = 3'b000;

// Combinational logic for next state
always @(*) begin
    case(state)
        3'b000: state <= data ? 3'b001 : 3'b000; // From IDLE, move to STATE1 on '1'
        3'b001: state <= data ? 3'b010 : 3'b000; // From STATE1, move to STATE2 on '1'
        3'b010: state <= ~data ? 3'b011 : 3'b010; // From STATE2, move to STATE3 on '0'
        3'b011: state <= data ? 3'b100 : 3'b000; // From STATE3, move to FINAL on '1', otherwise reset
        3'b100: state <= 3'b100; // Remain in FINAL state once reached
        default: state <= 3'b000; // Any other state, reset to IDLE
    endcase
end

// Synchronous reset and state update
always @(posedge clk) begin
    if(reset) begin
        state <= 3'b000; // Reset state to IDLE on reset
        start_shifting <= 0; // Clear start_shifting on reset
    end else begin
        // Update state based on combinational logic (implicitly done by always @(*) block)
        start_shifting <= (state == 3'b100); // Set start_shifting when FINAL state is reached
    end
end

endmodule