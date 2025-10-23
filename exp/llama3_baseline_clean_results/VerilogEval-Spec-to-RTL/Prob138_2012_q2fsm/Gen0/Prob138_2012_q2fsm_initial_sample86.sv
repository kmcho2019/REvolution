module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state, next_state;

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to state A (0)
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @ (*) begin
    case (state)
        3'b000: // State A
            if (w) next_state = 3'b001; // A (0) --1--> B
            else next_state = 3'b000; // A (0) --0--> A
        3'b001: // State B
            if (w) next_state = 3'b010; // B (0) --1--> C
            else next_state = 3'b011; // B (0) --0--> D
        3'b010: // State C
            if (w) next_state = 3'b100; // C (0) --1--> E
            else next_state = 3'b011; // C (0) --0--> D
        3'b011: // State D
            if (w) next_state = 3'b101; // D (0) --1--> F
            else next_state = 3'b000; // D (0) --0--> A
        3'b100: // State E
            if (w) next_state = 3'b100; // E (1) --1--> E
            else next_state = 3'b011; // E (1) --0--> D
        3'b101: // State F
            if (w) next_state = 3'b010; // F (1) --1--> C
            else next_state = 3'b011; // F (1) --0--> D
        default: next_state = 3'b000; // Default to state A
    endcase
end

// Output logic: Since the output z wasn't explicitly defined in terms of inputs or states in the question,
// we'll have to make an assumption. Given the transitions are based on w and state, but no specific z output
// condition is mentioned, let's assume z is high when in states E or F, which are the only states that have
// transitions based on w=1, indicating some special condition met in those states.
assign z = (state == 3'b100) | (state == 3'b101);

endmodule