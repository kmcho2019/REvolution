module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg [0:0] current_state; // current state

// State transition logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b0; // Reset to OFF state
    end else begin
        case (current_state)
            1'b0: current_state <= j? 1'b1 : 1'b0; // OFF state
            1'b1: current_state <= ~k? 1'b1 : 1'b0; // ON state
            default: current_state <= 1'b0; // Default to OFF state
        endcase
    end
end

// Output generation
always @(posedge clk) begin
    case (current_state)
        1'b0: out <= 1'b0; // Output 0 when in OFF state
        1'b1: out <= 1'b1; // Output 1 when in ON state
        default: out <= 1'b0; // Default to output 0
    endcase
end

endmodule