module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg current_state; // current state

// State register update logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b0; // Reset to OFF state
    end else begin
        case ({current_state, j, k})
            3'b000, 3'b001, 3'b010: current_state <= 1'b0; // Stay in OFF or transition based on j
            3'b011: current_state <= 1'b1; // Transition to ON based on j
            3'b100, 3'b101: current_state <= 1'b1; // Stay in ON or transition based on k
            3'b110: current_state <= 1'b0; // Transition to OFF based on k
            default: current_state <= 1'b0;
        endcase
    end
end

// Output logic directly from state
assign out = current_state;

endmodule