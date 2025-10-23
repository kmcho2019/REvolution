module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

// One-hot encoded states
reg [1:0] current_state; // current state

// Initialize state to OFF on reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 2'b01; // Reset to OFF state
    end else begin
        case (current_state)
            2'b01: // OFF state
                current_state <= (j)? 2'b10 : 2'b01;
            2'b10: // ON state
                current_state <= (~k)? 2'b10 : 2'b01;
            default:
                current_state <= 2'b01; // Default to OFF if unknown state
        endcase
    end
end

// Output logic
assign out = current_state[1]; // out is '1' when in ON state

endmodule