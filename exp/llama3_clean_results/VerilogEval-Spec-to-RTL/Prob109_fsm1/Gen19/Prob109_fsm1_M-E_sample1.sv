module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg [0:0] state; // 1 represents state B, 0 represents state A
reg [0:0] next_state;

// Combinational logic to generate next state and output
always @(*)
begin
    case (state)
        1'b0: // State A
            begin
                if (!in) next_state = 1'b1; // A (0) --0--> B
                else next_state = 1'b0; // A (0) --1--> A
            end
        1'b1: // State B
            begin
                if (!in) next_state = 1'b0; // B (1) --0--> A
                else next_state = 1'b1; // B (1) --1--> B
            end
        default: next_state = 1'b1; // Default to state B
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge areset)
begin
    if (areset) state <= 1'b1; // Reset to state B
    else state <= next_state; // Update state
end

// Output logic (Moore machine, output based on current state)
assign out = state;

endmodule