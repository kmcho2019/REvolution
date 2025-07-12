module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Current state
reg next_state; // Next state
reg output; // Output

// State machine's truth table
always @(*) begin
    case({state, in})
        2'b00: begin next_state = 1'b1; output = 1'b0; end
        2'b01: begin next_state = 1'b1; output = 1'b0; end
        2'b10: begin next_state = 1'b0; output = 1'b1; end
        2'b11: begin next_state = 1'b1; output = 1'b0; end
        default: begin next_state = 1'b0; output = 1'b1; end
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0; // Reset state is B
        out <= 1'b1;
    end else begin
        state <= next_state;
        out <= output;
    end
end

endmodule