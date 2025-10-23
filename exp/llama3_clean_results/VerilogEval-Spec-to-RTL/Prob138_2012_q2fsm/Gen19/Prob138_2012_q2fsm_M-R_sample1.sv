module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state;
reg [2:0] next_state;

// State transition logic
always @ (*) begin
    case (state)
        3'b000: next_state = w ? 3'b001 : 3'b000; // State A
        3'b001: next_state = w ? 3'b010 : 3'b011; // State B
        3'b010: next_state = w ? 3'b100 : 3'b011; // State C
        3'b011: next_state = w ? 3'b101 : 3'b000; // State D
        3'b100: next_state = w ? 3'b100 : 3'b011; // State E
        3'b101: next_state = w ? 3'b010 : 3'b011; // State F
        default: next_state = 3'b000; // Default to state A
    endcase
end

// State register
always @ (posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Output z
assign z = (state == 3'b100) || (state == 3'b101); // z is high when state is E or F

endmodule