module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] state, next_state;

always @(*) begin
    case (state)
        3'b000: // A
            if (~w) next_state = 3'b001; // A (0) --0--> B
            else next_state = 3'b000; // A (0) --1--> A
        3'b001: // B
            if (~w) next_state = 3'b010; // B (0) --0--> C
            else next_state = 3'b011; // B (0) --1--> D
        3'b010: // C
            if (~w) next_state = 3'b100; // C (0) --0--> E
            else next_state = 3'b011; // C (0) --1--> D
        3'b011: // D
            if (~w) next_state = 3'b101; // D (0) --0--> F
            else next_state = 3'b000; // D (0) --1--> A
        3'b100: // E
            if (w) begin
                if (~w) next_state = 3'b100; // E (1) --0--> E
                else next_state = 3'b011; // E (1) --1--> D
            end
            else next_state = 3'b100; // default
        3'b101: // F
            if (w) begin
                if (~w) next_state = 3'b010; // F (1) --0--> C
                else next_state = 3'b011; // F (1) --1--> D
            end
            else next_state = 3'b101; // default
        default: next_state = 3'b000; // default state
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) state <= 3'b000; // reset to state A
    else state <= next_state;
end

always @(*) begin
    case (state)
        3'b000, 3'b001, 3'b010, 3'b011: z = 0; // states A, B, C, D
        3'b100, 3'b101: z = 1; // states E, F
        default: z = 0; // default output
    endcase
end

endmodule