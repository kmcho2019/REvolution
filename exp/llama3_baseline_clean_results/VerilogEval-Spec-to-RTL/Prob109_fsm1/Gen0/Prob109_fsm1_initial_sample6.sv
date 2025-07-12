module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // Using a single bit for state (0 - A, 1 - B)
reg [0:0] next_state;

// Output is directly derived from the state for simplicity
assign out = state;

always @(*) begin
    case(state)
        1'b0: // State A
            if(in == 1'b1)
                next_state = 1'b0; // Stay in A
            else
                next_state = 1'b1; // Go to B
        1'b1: // State B
            if(in == 1'b1)
                next_state = 1'b1; // Stay in B
            else
                next_state = 1'b0; // Go to A
        default: next_state = 1'b1; // Default to state B
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

endmodule