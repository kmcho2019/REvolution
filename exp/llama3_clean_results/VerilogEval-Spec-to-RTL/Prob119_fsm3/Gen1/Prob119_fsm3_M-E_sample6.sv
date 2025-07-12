module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

// Define states using one-hot encoding
reg [3:0] currentState, nextState;

// Combinational logic for next state
always_comb begin
    case (currentState)
        4'b0001: nextState = (in)? 4'b0010 : 4'b0001; // A
        4'b0010: nextState = (in)? 4'b0010 : 4'b0100; // B
        4'b0100: nextState = (in)? 4'b1000 : 4'b0001; // C
        4'b1000: nextState = (in)? 4'b0010 : 4'b0100; // D
        default: nextState = 4'b0001; // Default state A
    endcase
end

// Sequential logic for current state and output
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        currentState <= 4'b0001; // Reset to state A
    end else begin
        currentState <= nextState;
    end
end

// Combinational logic for output
assign out = (currentState == 4'b1000)? 1'b1 : 1'b0; // Output 1 when in state D, 0 otherwise

endmodule