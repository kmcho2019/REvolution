module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Encoding: A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 3'b000; // Initialize to state A
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        3'b000: // State A
            if (!w) next_state = 3'b001; // A (0) --> B
            else next_state = 3'b000; // A (0) --> A
        3'b001: // State B
            if (!w) next_state = 3'b010; // B (0) --> C
            else next_state = 3'b011; // B (0) --> D
        3'b010: // State C
            if (!w) next_state = 3'b100; // C (0) --> E
            else next_state = 3'b011; // C (0) --> D
        3'b011: // State D
            if (!w) next_state = 3'b101; // D (0) --> F
            else next_state = 3'b000; // D (0) --> A
        3'b100: // State E
            if (!w) next_state = 3'b100; // E (1) --> E
            else next_state = 3'b011; // E (1) --> D
        3'b101: // State F
            if (!w) next_state = 3'b010; // F (1) --> C
            else next_state = 3'b011; // F (1) --> D
        default: next_state = 3'b000; // Default to state A
    endcase
end

// Derive output z based on the current state and input w
assign z = (current_state == 3'b100 || current_state == 3'b101) ? w : 1'b0;

endmodule