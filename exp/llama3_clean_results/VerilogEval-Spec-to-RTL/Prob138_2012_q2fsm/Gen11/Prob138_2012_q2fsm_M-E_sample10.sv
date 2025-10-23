module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Binary-encoded state register
reg [2:0] state;
reg [2:0] next_state;

// Lookup table (LUT) for state transitions
always @(*)
begin
    case (state)
        3'b000: next_state = (w) ? 3'b001 : 3'b000; // State A
        3'b001: next_state = (w) ? 3'b010 : 3'b011; // State B
        3'b010: next_state = (w) ? 3'b100 : 3'b011; // State C
        3'b011: next_state = (w) ? 3'b101 : 3'b000; // State D
        3'b100: next_state = (w) ? 3'b100 : 3'b011; // State E
        3'b101: next_state = (w) ? 3'b010 : 3'b011; // State F
        default: next_state = 3'b000; // Default state
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (reset)
        state <= 3'b000;
    else
        state <= next_state;
end

// Output z
assign z = (state == 3'b100 || state == 3'b101);

endmodule