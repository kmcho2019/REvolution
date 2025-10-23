module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

// Define the states as enumerations
parameter OFF = 1'b0;
parameter ON  = 1'b1;

reg current_state; // current state

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case ({current_state, j, k})
            3'b000, 3'b001: current_state <= OFF;
            3'b010: current_state <= ON;
            3'b011, 3'b101: current_state <= ON;
            3'b100, 3'b111: current_state <= OFF;
            default: current_state <= OFF;
        endcase
    end
end

// Output logic directly from state
assign out = current_state;

endmodule