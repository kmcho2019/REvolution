module TopModule(
    input clk,
    input reset,
    input in,
    output reg out // Declare out as a reg
);

// Parameterized state type
parameter STATE_B = 1'b1, STATE_A = 1'b0;
reg [0:0] state, next_state; // Use reg for state and next_state

// State Register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= STATE_B;
    end else begin
        state <= next_state;
    end
end

// Next State Logic and Output Logic
always_comb begin
    case (state)
        STATE_B: begin
            if (~in) begin
                next_state = STATE_A;
            end else begin
                next_state = STATE_B;
            end
            out = 1'b1; // Determine output based on current state
        end
        STATE_A: begin
            if (~in) begin
                next_state = STATE_B;
            end else begin
                next_state = STATE_A;
            end
            out = 1'b0; // Determine output based on current state
        end
    endcase
end

endmodule