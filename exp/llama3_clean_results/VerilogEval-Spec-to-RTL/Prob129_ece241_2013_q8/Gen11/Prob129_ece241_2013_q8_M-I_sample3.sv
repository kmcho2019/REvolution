module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // Current state of the FSM

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00; // Reset state to 00
    end else begin
        case(state)
            2'b00: if (x) state <= 2'b01; // Move to state 01 if x is 1
            2'b01: if (x) state <= 2'b10; else state <= 2'b00; // Move to state 10 if x is 1, otherwise reset to 00
            2'b10: if (!x) state <= 2'b00; // Reset to state 00 if x is 0
            default: state <= 2'b00; // Default case for invalid states
        endcase
    end
end

// Output logic
assign z = (state == 2'b10);

endmodule