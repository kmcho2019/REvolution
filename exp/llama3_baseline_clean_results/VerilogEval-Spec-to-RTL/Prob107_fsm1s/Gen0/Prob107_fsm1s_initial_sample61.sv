module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // Using 1-bit to represent two states
reg [0:0] next_state;

// Output logic
always @(*)
begin
    case(state)
        1'b0: out = 1'b1; // State B
        1'b1: out = 1'b0; // State A
        default: out = 1'b0;
    endcase
end

// Next state logic
always @(*)
begin
    case(state)
        1'b0: // State B
            begin
                if(~in)
                    next_state = 1'b1; // Transition to A
                else
                    next_state = 1'b0; // Stay in B
            end
        1'b1: // State A
            begin
                if(~in)
                    next_state = 1'b0; // Transition to B
                else
                    next_state = 1'b1; // Stay in A
            end
        default: next_state = 1'b0;
    endcase
end

// State update
always @(posedge clk)
begin
    if(reset)
        state <= 1'b0; // Reset to state B
    else
        state <= next_state;
end

endmodule