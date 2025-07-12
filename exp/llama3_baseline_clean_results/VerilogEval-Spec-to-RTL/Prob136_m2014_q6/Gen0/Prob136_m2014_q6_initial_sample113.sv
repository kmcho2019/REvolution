module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Enumerating states (though in this case, we're using binary encoding directly)
// States: A (3'b000), B (3'b001), C (3'b010), D (3'b011), E (3'b100), F (3'b101)
reg [2:0] currentState;
reg [2:0] nextState;

// Output z is assumed to be high when in state E or F, low otherwise
assign z = (currentState == 3'b100) || (currentState == 3'b101);

always @(*) begin
    case(currentState)
        3'b000: nextState = w ? 3'b000 : 3'b001; // A
        3'b001: nextState = w ? 3'b011 : 3'b010; // B
        3'b010: nextState = w ? 3'b011 : 3'b100; // C
        3'b011: nextState = w ? 3'b000 : 3'b101; // D
        3'b100: nextState = w ? 3'b011 : 3'b100; // E
        3'b101: nextState = w ? 3'b011 : 3'b010; // F
        default: nextState = 3'b000; // Default to A for unused states
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        currentState <= 3'b000; // Reset to state A
    end else begin
        currentState <= nextState;
    end
end

endmodule