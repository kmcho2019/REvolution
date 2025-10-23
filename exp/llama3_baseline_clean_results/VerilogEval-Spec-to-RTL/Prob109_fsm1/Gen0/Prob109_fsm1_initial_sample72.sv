module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [0:0] state; // 1-bit register to store the current state
reg [0:0] next_state; // 1-bit register to store the next state

// Output logic
assign out = (state == 1'b1) ? 1'b1 : 1'b0; // Output is 1 when in state B, 0 when in state A

// Next state logic
always @(*) begin
    case (state)
        1'b0: next_state = (in == 1'b1) ? 1'b0 : 1'b1; // In state A, go to B on 0, stay in A on 1
        1'b1: next_state = (in == 1'b1) ? 1'b1 : 1'b0; // In state B, go to A on 0, stay in B on 1
        default: next_state = 1'b1; // Default to state B
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

endmodule