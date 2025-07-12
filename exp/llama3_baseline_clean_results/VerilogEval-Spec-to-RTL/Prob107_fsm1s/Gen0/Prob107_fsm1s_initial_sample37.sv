module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] current_state; // Using 1 bit for two states (0 - B, 1 - A)
reg [0:0] next_state;

always @(*) begin
    case(current_state)
        1'b0: begin // State B
            if (~in) next_state = 1'b1; // If in is 0, go to state A
            else next_state = 1'b0; // If in is 1, stay in state B
        end
        1'b1: begin // State A
            if (~in) next_state = 1'b0; // If in is 0, go to state B
            else next_state = 1'b1; // If in is 1, stay in state A
        end
        default: next_state = 1'b0; // Default to state B
    endcase
end

always @(posedge clk) begin
    if (reset) begin // Active-high synchronous reset
        current_state <= 1'b0; // Reset to state B
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        1'b0: out = 1'b1; // State B, out = 1
        1'b1: out = 1'b0; // State A, out = 0
        default: out = 1'b1; // Default to state B, out = 1
    endcase
end

endmodule