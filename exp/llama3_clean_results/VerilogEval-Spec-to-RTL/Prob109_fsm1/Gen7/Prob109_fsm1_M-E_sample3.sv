module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg [1:0] state; // 2'b01 represents state B, 2'b10 represents state A
reg [1:0] nextState;
reg [1:0] lut[2:0]; // LUT to store next state and output

// Initialize LUT
initial begin
    lut[0] = 2'b01; // State B, input 0: next state B
    lut[1] = 2'b10; // State B, input 1: next state A
    lut[2] = 2'b01; // State A, input 0: next state B
    lut[3] = 2'b10; // State A, input 1: next state A
end

// Combinational logic to determine next state
always @(*) begin
    case ({state, in})
        2'b01, 2'b11: nextState = lut[1]; // State B, input 0 or 1
        2'b10, 2'b00: nextState = lut[2]; // State A, input 0 or 1
        default: nextState = 2'b01; // Default to state B
    endcase
end

// Sequential logic to update state
always @(posedge clk or posedge areset)
begin
    if (areset) 
        state <= 2'b01; // Reset to state B
    else 
        state <= nextState;
end

// Output logic (Moore machine, output based on current state)
assign out = state[0]; // Output is the least significant bit of the state

endmodule