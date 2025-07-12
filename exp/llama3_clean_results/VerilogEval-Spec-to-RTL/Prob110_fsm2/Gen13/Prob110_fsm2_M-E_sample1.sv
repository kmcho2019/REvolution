module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

// One-hot encoding for states
reg [1:0] state; // Current state

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Initialize to OFF state
    end else begin
        case (state)
            2'b01: state <= j ? 2'b10 : 2'b01; // OFF state
            2'b10: state <= k ? 2'b01 : 2'b10; // ON state
            default: state <= 2'b01; // Default to OFF state
        endcase
    end
end

// Output logic directly from state
assign out = state[1]; // out is '1' when in ON state (2'b10)

endmodule