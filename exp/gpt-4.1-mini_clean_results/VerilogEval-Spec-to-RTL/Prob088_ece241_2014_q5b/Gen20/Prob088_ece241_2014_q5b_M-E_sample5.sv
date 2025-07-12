module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg state_A, state_B;         // one-hot encoded states
reg next_state_A, next_state_B;

// Combinational logic for next state and output
always @(*) begin
    // Default assignments to avoid latches
    next_state_A = state_A;
    next_state_B = state_B;
    z = 1'b0;

    if (state_A) begin
        // From state A
        if (x == 1'b0) begin
            next_state_A = 1'b1;
            next_state_B = 1'b0;
            z = 1'b0;
        end else begin
            next_state_A = 1'b0;
            next_state_B = 1'b1;
            z = 1'b1;
        end
    end else begin
        // From state B
        if (x == 1'b0) begin
            next_state_A = 1'b0;
            next_state_B = 1'b1;
            z = 1'b1;
        end else begin
            next_state_A = 1'b0;
            next_state_B = 1'b1;
            z = 1'b0;
        end
    end
end

// Sequential state register with async active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_A <= 1'b1;  // reset to state A
        state_B <= 1'b0;
    end else begin
        state_A <= next_state_A;
        state_B <= next_state_B;
    end
end

endmodule