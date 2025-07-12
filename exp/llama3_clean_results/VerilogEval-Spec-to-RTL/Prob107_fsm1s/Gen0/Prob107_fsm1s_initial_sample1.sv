module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
parameter B = 1'b0;  // Reset state
parameter A = 1'b1;

// Define the current state and next state
reg current_state;
reg next_state;

// Determine the output based on the current state
always @(current_state) begin
    case (current_state)
        B: out = 1'b1;
        A: out = 1'b0;
    endcase
end

// Determine the next state based on the current state and input
always @(current_state, in) begin
    case (current_state)
        B: begin
            if (in == 1'b0) next_state = A;
            else next_state = B;
        end
        A: begin
            if (in == 1'b0) next_state = B;
            else next_state = A;
        end
    endcase
end

// Update the current state on the rising edge of the clock
always @(posedge clk) begin
    if (reset == 1'b1) current_state <= B;  // Synchronous reset
    else current_state <= next_state;
end

endmodule