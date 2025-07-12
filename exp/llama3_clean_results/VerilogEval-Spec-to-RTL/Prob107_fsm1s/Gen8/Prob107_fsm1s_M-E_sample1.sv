module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] state; // Using a 1-bit register to represent the state

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
    end else begin
        case({state, in})
            2'b00: state <= 1; // Transition from B to A when in is 0
            2'b01: state <= 0; // Stay in B when in is 1
            2'b10: state <= 0; // Transition from A to B when in is 0
            2'b11: state <= 1; // Stay in A when in is 1
        endcase
    end
end

assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

endmodule