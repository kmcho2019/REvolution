module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state, next_state;

// State table
always @(*) begin
    case (state)
        3'b000: next_state = w ? 3'b001 : 3'b000;  // A
        3'b001: next_state = w ? 3'b010 : 3'b011;  // B
        3'b010: next_state = w ? 3'b100 : 3'b011;  // C
        3'b011: next_state = w ? 3'b101 : 3'b000;  // D
        3'b100: next_state = w ? 3'b100 : 3'b011;  // E
        3'b101: next_state = w ? 3'b010 : 3'b011;  // F
        default: next_state = 3'b000;  // Default state
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;  // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Output z
always @(*) begin
    case (state)
        3'b100, 3'b101: z = 1'b1;  // E and F
        default: z = 1'b0;  // A, B, C, and D
    endcase
end

endmodule