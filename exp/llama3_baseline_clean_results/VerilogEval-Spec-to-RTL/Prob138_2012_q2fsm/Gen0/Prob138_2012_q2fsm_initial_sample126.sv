module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

reg [2:0] currentState;
reg [2:0] nextState;

always @(*) begin
    case(currentState)
        3'b000: nextState = w ? 3'b001 : 3'b000;
        3'b001: nextState = w ? 3'b010 : 3'b011;
        3'b010: nextState = w ? 3'b100 : 3'b011;
        3'b011: nextState = w ? 3'b101 : 3'b000;
        3'b100: nextState = w ? 3'b100 : 3'b011;
        3'b101: nextState = w ? 3'b010 : 3'b011;
        default: nextState = 3'b000;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        currentState <= 3'b000;
    end else begin
        currentState <= nextState;
    end
end

always @(*) begin
    case(currentState)
        3'b000: z = 0;
        3'b001: z = 0;
        3'b010: z = 0;
        3'b011: z = 0;
        3'b100: z = 1;
        3'b101: z = 1;
        default: z = 0;
    endcase
end

endmodule