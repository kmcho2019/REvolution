module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg [1:0] state; // One-Hot encoded state

// State register update and next-state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to OFF state
    end else begin
        case (state)
            2'b01: // OFF state
                state <= j ? 2'b10 : 2'b01;
            2'b10: // ON state
                state <= k ? 2'b01 : 2'b10;
            default:
                state <= 2'b01;
        endcase
    end
end

// Output logic directly from state
assign out = state[1]; // out is '1' when in ON state

endmodule