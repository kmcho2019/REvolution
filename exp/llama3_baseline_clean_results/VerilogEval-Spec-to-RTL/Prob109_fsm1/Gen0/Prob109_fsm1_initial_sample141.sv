module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
parameter A = 1'b0;
parameter B = 1'b1;

reg current_state;
reg next_state;

// Asynchronous reset
always @(areset or current_state or in) begin
    if (areset) begin
        current_state = B;
    end else begin
        case (current_state)
            B: next_state = (in == 1'b1) ? B : A;
            A: next_state = (in == 1'b1) ? A : B;
            default: next_state = B; // Default to B if in an invalid state
        endcase
    end
end

// Synchronous state update
always @(posedge clk) begin
    current_state <= next_state;
end

// Continuous assignment for output
assign out = (current_state == B) ? 1'b1 : 1'b0;

endmodule