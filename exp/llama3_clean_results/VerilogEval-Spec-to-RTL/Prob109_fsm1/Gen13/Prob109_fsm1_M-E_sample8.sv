module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg state; // Current state

// LUT for next state and output
reg [1:0] lut[1:0];
initial begin
    lut[0] = 2'b10; // State A, input 0: next state B, output 0
    lut[1] = 2'b00; // State A, input 1: next state A, output 0
    lut[2] = 2'b01; // State B, input 0: next state A, output 1
    lut[3] = 2'b11; // State B, input 1: next state B, output 1
end

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Reset to state B (1)
    end else begin
        // Next state logic using LUT
        {state, out} <= lut[{state, in}];
    end
end

endmodule