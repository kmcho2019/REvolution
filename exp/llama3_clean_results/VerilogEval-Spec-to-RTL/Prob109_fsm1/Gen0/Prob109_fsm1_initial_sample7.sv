module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg [0:0] state; // 0 represents state B, 1 represents state A
reg [0:0] next_state;

// Combinational logic to determine next state
always @(*)
begin
    case(state)
        0: // State B
            begin
                if (in == 0) next_state = 1; // Go to A
                else next_state = 0; // Stay in B
            end
        1: // State A
            begin
                if (in == 0) next_state = 0; // Go to B
                else next_state = 1; // Stay in A
            end
        default: next_state = 0; // Default to state B
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge areset)
begin
    if (areset) state <= 0; // Reset to state B
    else state <= next_state;
end

// Output logic (Moore machine, output based on current state)
assign out = state;

endmodule