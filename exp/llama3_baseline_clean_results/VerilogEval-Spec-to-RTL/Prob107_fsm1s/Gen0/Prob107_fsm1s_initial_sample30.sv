module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] current_state;  // Initialize current state to 0 (B)
reg [0:0] next_state;    // Next state variable

// State encoding: B = 0, A = 1

always @(*) begin
    case (current_state)
        0: begin  // State B
            if (~in) begin  // in = 0
                next_state = 1;  // Go to state A
            end else begin
                next_state = 0;  // Stay in state B
            end
        end
        1: begin  // State A
            if (~in) begin  // in = 0
                next_state = 0;  // Go to state B
            end else begin
                next_state = 1;  // Stay in state A
            end
        end
        default: next_state = 0;  // Default to state B
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= 0;  // Reset to state B
    end else begin
        current_state <= next_state;  // Update current state
    end
end

always @(*) begin
    case (current_state)
        0: out = 1;  // State B, out = 1
        1: out = 0;  // State A, out = 0
        default: out = 1;  // Default out = 1
    endcase
end

endmodule