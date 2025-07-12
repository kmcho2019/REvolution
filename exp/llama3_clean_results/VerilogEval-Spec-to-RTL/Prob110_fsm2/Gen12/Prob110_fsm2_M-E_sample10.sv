module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg [1:0] current_state; // current state using One-Hot encoding

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 2'b01; // Reset to OFF state
    end else begin
        case (current_state)
            2'b01: current_state <= (j) ? 2'b10 : 2'b01;
            2'b10: current_state <= (k) ? 2'b01 : 2'b10;
            default: current_state <= 2'b01;
        endcase
    end
end

// Output logic directly from state
assign out = current_state[1];

endmodule