module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state; // 3-bit register to represent states
reg [2:0] nextState; // 3-bit register to store next state

// State machine using multiplexers and demultiplexers
always @ (posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to state A
    end else begin
        case (state)
            3'b000: nextState = w ? 3'b001 : 3'b000; // State A
            3'b001: nextState = w ? 3'b010 : 3'b011; // State B
            3'b010: nextState = w ? 3'b100 : 3'b011; // State C
            3'b011: nextState = w ? 3'b101 : 3'b000; // State D
            3'b100: nextState = w ? 3'b100 : 3'b011; // State E
            3'b101: nextState = w ? 3'b010 : 3'b011; // State F
            default: nextState = 3'b000; // Default to state A
        endcase
        state <= nextState;
    end
end

// Output z using demultiplexers
assign z = (state == 3'b100) || (state == 3'b101); // z is high when state is E or F

endmodule