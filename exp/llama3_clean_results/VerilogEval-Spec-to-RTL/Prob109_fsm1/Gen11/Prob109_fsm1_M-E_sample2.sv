module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit signal representing the current state
reg next_state; // 1-bit signal representing the next state
reg output_value; // 1-bit signal representing the output value

// Look-up table (LUT) for next state and output
always @(*) begin
    case ({state, in})
        2'b00: begin next_state = 1'b1; output_value = 1'b0; end
        2'b01: begin next_state = 1'b0; output_value = 1'b0; end
        2'b10: begin next_state = 1'b1; output_value = 1'b1; end
        2'b11: begin next_state = 1'b1; output_value = 1'b1; end
    endcase
end

// Update state on clock edge
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

// Out is directly derived from the state in this implementation
assign out = state;

endmodule