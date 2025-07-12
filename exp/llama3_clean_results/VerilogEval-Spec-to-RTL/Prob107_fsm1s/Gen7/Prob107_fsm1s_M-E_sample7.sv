module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // Using a 2-bit register to represent the state
wire [1:0] nextState;

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset state is B, represented by binary '00'
    end else begin
        state <= nextState; // Update state
    end
end

always @(*) begin
    case(state)
        2'b00: nextState = (in == 1'b0) ? 2'b01 : 2'b00; // State B
        2'b01: nextState = (in == 1'b0) ? 2'b00 : 2'b01; // State A
        default: nextState = 2'b00; // Default state
    endcase
end

assign out = (state == 2'b00) ? 1'b1 : 1'b0; // Output is 1 in state B (00) and 0 in state A (01)

endmodule