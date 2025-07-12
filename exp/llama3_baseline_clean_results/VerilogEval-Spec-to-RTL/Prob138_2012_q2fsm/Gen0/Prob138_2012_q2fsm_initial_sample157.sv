module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state, next_state;

// State Flip-Flops
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// State Table
always @(*) begin
    case (state)
        3'b000: // State A
            next_state = w ? 3'b001 : 3'b000; // A (0) --1--> B, A (0) --0--> A
        3'b001: // State B
            next_state = w ? 3'b010 : 3'b011; // B (0) --1--> C, B (0) --0--> D
        3'b010: // State C
            next_state = w ? 3'b100 : 3'b011; // C (0) --1--> E, C (0) --0--> D
        3'b011: // State D
            next_state = w ? 3'b101 : 3'b000; // D (0) --1--> F, D (0) --0--> A
        3'b100: // State E
            next_state = w ? 3'b100 : 3'b011; // E (1) --1--> E, E (1) --0--> D
        3'b101: // State F
            next_state = w ? 3'b010 : 3'b011; // F (1) --1--> C, F (1) --0--> D
        default:
            next_state = 3'b000; // Default to state A
    endcase
end

// Output z
always @(*) begin
    case (state)
        3'b000: z = 0; // State A
        3'b001: z = 0; // State B
        3'b010: z = 0; // State C
        3'b011: z = 0; // State D
        3'b100: z = 1; // State E
        3'b101: z = 1; // State F
        default: z = 0; // Default output
    endcase
end

endmodule