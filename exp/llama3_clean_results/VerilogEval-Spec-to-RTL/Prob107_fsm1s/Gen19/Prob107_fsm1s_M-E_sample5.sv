module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // State variable (2 states)
reg [1:0] next_state; // Next state variable

// Lookup table for state transitions and output
always @(*) begin
    case({state, in})
        2'b00: begin next_state = 2'b01; out = 1'b1; end
        2'b01: begin next_state = 2'b01; out = 1'b1; end
        2'b10: begin next_state = 2'b00; out = 1'b0; end
        2'b11: begin next_state = 2'b10; out = 1'b0; end
        default: begin next_state = 2'b00; out = 1'b1; end
    endcase
end

// D-flip flop to update the state
always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset to state B (out=1)
    end else begin
        state <= next_state;
    end
end

endmodule