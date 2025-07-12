module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] current_state;  // Declare the current state as a 2-bit reg
reg [1:0] next_state;     // Declare the next state as a 2-bit reg

// Combinational logic to determine the next state using One-Hot Encoding
always @(*) begin
    case (current_state)
        2'b01: next_state = (in == 1'b1) ? 2'b01 : 2'b10;  // State A
        2'b10: next_state = (in == 1'b0) ? 2'b01 : 2'b10;  // State B
        default: next_state = 2'b10;  // Default to state B
    endcase
end

// Sequential logic to update the current state
always @(posedge clk) begin
    if (reset) begin
        current_state <= 2'b10;  // Reset to state B
    end else begin
        current_state <= next_state;
    end
end

// Determine the output based on the current state
assign out = (current_state == 2'b10) ? 1'b1 : 1'b0;

endmodule