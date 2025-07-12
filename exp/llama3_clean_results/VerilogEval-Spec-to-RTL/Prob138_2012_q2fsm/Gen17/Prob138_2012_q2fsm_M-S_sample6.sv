module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state; // 3-bit state register

// State machine
always @ (posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to state A
    end else begin
        case (state)
            3'b000: state <= w ? 3'b001 : state; // State A
            3'b001: state <= w ? 3'b010 : 3'b011; // State B
            3'b010: state <= w ? 3'b100 : 3'b011; // State C
            3'b011: state <= w ? 3'b101 : 3'b000; // State D
            3'b100, 3'b101: state <= w ? state : 3'b011; // States E and F
            default: state <= 3'b000; // Default to state A
        endcase
    end
end

// Output z
assign z = (state == 3'b100) || (state == 3'b101); // z is high when state is E or F

endmodule