module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        current_state <= 3'b000; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        3'b000: // State A
            if (w) begin
                next_state = 3'b001; // A (0) --1--> B
            end else begin
                next_state = 3'b000; // A (0) --0--> A
            end
        3'b001: // State B
            if (w) begin
                next_state = 3'b010; // B (0) --1--> C
            end else begin
                next_state = 3'b011; // B (0) --0--> D
            end
        3'b010: // State C
            if (w) begin
                next_state = 3'b100; // C (0) --1--> E
            end else begin
                next_state = 3'b011; // C (0) --0--> D
            end
        3'b011: // State D
            if (w) begin
                next_state = 3'b101; // D (0) --1--> F
            end else begin
                next_state = 3'b000; // D (0) --0--> A
            end
        3'b100: // State E
            if (w) begin
                next_state = 3'b100; // E (1) --1--> E
            end else begin
                next_state = 3'b011; // E (1) --0--> D
            end
        3'b101: // State F
            if (w) begin
                next_state = 3'b010; // F (1) --1--> C
            end else begin
                next_state = 3'b011; // F (1) --0--> D
            end
        default: next_state = 3'b000; // Invalid state, reset to A
    endcase
end

// Output z
assign z = (current_state == 3'b100) | (current_state == 3'b101);

endmodule