module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state;
reg [2:0] next_state;

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// State table simplified
always @ (*) begin
    next_state = state; // Default to current state
    case (state)
        3'b000: // A
            next_state = w ? 3'b001 : 3'b000;
        3'b001: // B
            next_state = w ? 3'b010 : 3'b011;
        3'b010: // C
            next_state = w ? 3'b100 : 3'b011;
        3'b011: // D
            next_state = w ? 3'b101 : 3'b000;
        3'b100: // E
            next_state = w ? 3'b100 : 3'b011;
        3'b101: // F
            next_state = w ? 3'b010 : 3'b011;
    endcase
end

// Alternatively, using conditional statements instead of case
// always @ (*) begin
//     next_state = state; // Default to current state
//     if (state == 3'b000) next_state = w ? 3'b001 : 3'b000;
//     else if (state == 3'b001) next_state = w ? 3'b010 : 3'b011;
//     else if (state == 3'b010) next_state = w ? 3'b100 : 3'b011;
//     else if (state == 3'b011) next_state = w ? 3'b101 : 3'b000;
//     else if (state == 3'b100) next_state = w ? 3'b100 : 3'b011;
//     else if (state == 3'b101) next_state = w ? 3'b010 : 3'b011;
// end

// Output z
assign z = state[2]; // z is high when state is E or F

endmodule