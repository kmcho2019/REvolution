module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // Current state
reg [0:0] next_state; // Next state

// Define the states
parameter B = 1'b1; // State B
parameter A = 1'b0; // State A

// Output logic
always @(*) begin
    case (state)
        B: out = 1'b1; // In state B, out is 1
        A: out = 1'b0; // In state A, out is 0
        default: out = 1'bx; // Invalid state, output is unknown
    endcase
end

// Next state logic
always @(*) begin
    case (state)
        B: begin
            if (in == 1'b0) begin
                next_state = A; // From B, in=0 goes to A
            end else begin
                next_state = B; // From B, in=1 stays in B
            end
        end
        A: begin
            if (in == 1'b0) begin
                next_state = B; // From A, in=0 goes to B
            end else begin
                next_state = A; // From A, in=1 stays in A
            end
        end
        default: next_state = 1'bx; // Invalid state, next state is unknown
    endcase
end

// State register with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        state <= B; // Synchronous reset to state B
    end else begin
        state <= next_state; // Update state on the next clock edge
    end
end

endmodule