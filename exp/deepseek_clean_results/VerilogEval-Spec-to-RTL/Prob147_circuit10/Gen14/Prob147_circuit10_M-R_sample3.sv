module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;
wire state_next;

// State transition logic
assign state_next = (a & b) ? ~state_reg :  // Toggle if both inputs high
                    (~a & ~b) ? 1'b1 :       // Set if both inputs low
                    state_reg;               // Otherwise maintain state

// Sequential state update
always @(posedge clk) begin
    state_reg <= state_next;
end

// Output logic
assign q = (a ^ b) | (state_reg & (a | b));
assign state = state_reg;

endmodule