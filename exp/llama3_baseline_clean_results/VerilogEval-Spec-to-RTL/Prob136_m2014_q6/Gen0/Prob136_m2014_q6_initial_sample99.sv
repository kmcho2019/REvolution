module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state;
reg [2:0] next_state;

// Output logic
always @(*) begin
    case (state)
        3'b000: z = 1'b0; // A
        3'b001: z = 1'b0; // B
        3'b010: z = 1'b0; // C
        3'b011: z = 1'b0; // D
        3'b100: z = 1'b1; // E
        3'b101: z = 1'b1; // F
        default: z = 1'b0;
    endcase
end

// Next state logic
always @(*) begin
    case (state)
        3'b000: next_state = (w) ? 3'b000 : 3'b001; // A
        3'b001: next_state = (w) ? 3'b011 : 3'b010; // B
        3'b010: next_state = (w) ? 3'b011 : 3'b100; // C
        3'b011: next_state = (w) ? 3'b000 : 3'b101; // D
        3'b100: next_state = (w) ? 3'b011 : 3'b100; // E
        3'b101: next_state = (w) ? 3'b011 : 3'b010; // F
        default: next_state = 3'b000;
    endcase
end

// State register
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule