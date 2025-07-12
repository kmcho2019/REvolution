module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

reg [2:0] state, next_state;

always @(*) begin
    case (state)
        3'b000: // A
            if (w) next_state = 3'b000;
            else next_state = 3'b001;
        3'b001: // B
            if (w) next_state = 3'b011;
            else next_state = 3'b010;
        3'b010: // C
            if (w) next_state = 3'b011;
            else next_state = 3'b100;
        3'b011: // D
            if (w) next_state = 3'b000;
            else next_state = 3'b101;
        3'b100: // E
            if (w) next_state = 3'b011;
            else next_state = 3'b100;
        3'b101: // F
            if (w) next_state = 3'b011;
            else next_state = 3'b010;
        default: next_state = 3'b000;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) state <= 3'b000;
    else state <= next_state;
end

always @(*) begin
    case (state)
        3'b000, 3'b001, 3'b010, 3'b011: z = 1'b0;
        3'b100, 3'b101: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule