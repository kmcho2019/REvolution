module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [5:0] state; // One-hot encoding for states A to F

// Next-state logic using a lookup table approach
always @ (posedge clk) begin
    if (reset) begin
        state <= 6'b000001; // Reset to state A
    end else begin
        case ({state, w})
            7'b0000010: state <= 6'b000010; // State A, w = 0 -> State A
            7'b0000011: state <= 6'b000010; // State A, w = 1 -> State B
            7'b0000100: state <= 6'b000100; // State B, w = 0 -> State D
            7'b0000101: state <= 6'b001000; // State B, w = 1 -> State C
            7'b0001000: state <= 6'b000001; // State D, w = 0 -> State A
            7'b0001001: state <= 6'b010000; // State D, w = 1 -> State F
            7'b0010000: state <= 6'b000100; // State C, w = 0 -> State D
            7'b0010001: state <= 6'b100000; // State C, w = 1 -> State E
            7'b0100000: state <= 6'b000100; // State F, w = 0 -> State D
            7'b0100001: state <= 6'b001000; // State F, w = 1 -> State C
            7'b1000000: state <= 6'b000100; // State E, w = 0 -> State D
            7'b1000001: state <= 6'b100000; // State E, w = 1 -> State E
            default: state <= 6'b000001; // Default to state A
        endcase
    end
end

// Output z
assign z = state[4] | state[5]; // z is high when state is E or F

endmodule