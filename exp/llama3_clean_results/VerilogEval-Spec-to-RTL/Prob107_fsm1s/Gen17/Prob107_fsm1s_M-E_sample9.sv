module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // Current state (One-Hot encoding)
reg [1:0] next_state; // Next state

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 2'b10; // Reset to STATE_B
    end else begin
        state <= next_state; // Update state
    end
end

always @(*) begin
    case(state)
        2'b10: next_state = (in == 0)? 2'b01 : 2'b10; // STATE_B
        2'b01: next_state = (in == 0)? 2'b10 : 2'b01; // STATE_A
        default: next_state = 2'b10; // Default to STATE_B
    endcase
end

always @(*) begin
    case(state)
        2'b10: out = 1'b1; // STATE_B
        2'b01: out = 1'b0; // STATE_A
        default: out = 1'b1; // Default to STATE_B
    endcase
end

endmodule