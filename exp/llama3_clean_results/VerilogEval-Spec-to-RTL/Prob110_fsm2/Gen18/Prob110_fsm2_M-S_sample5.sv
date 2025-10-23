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
        case (current_state)
            1'b0: current_state <= j? 1'b1 : 1'b0; // OFF state
            1'b1: current_state <= k? 1'b0 : 1'b1; // ON state
            default: current_state <= 1'b0;
        endcase
    end
end

// Output logic directly from state
assign out = current_state;

endmodule