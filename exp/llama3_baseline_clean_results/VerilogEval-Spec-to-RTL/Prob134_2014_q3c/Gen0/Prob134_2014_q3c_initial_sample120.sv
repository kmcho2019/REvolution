module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] currentState, nextState;

always @(*) begin
    case(currentState)
        3'b000: if (!x) nextState = 3'b000; else nextState = 3'b001;
        3'b001: if (!x) nextState = 3'b001; else nextState = 3'b100;
        3'b010: if (!x) nextState = 3'b010; else nextState = 3'b001;
        3'b011: if (!x) nextState = 3'b001; else nextState = 3'b010;
        3'b100: if (!x) nextState = 3'b011; else nextState = 3'b100;
        default: nextState = 3'b000; // For unspecified states, reset to 000
    endcase
end

always @(posedge clk) begin
    currentState <= nextState;
end

assign Y0 = nextState[0]; // Assign the least significant bit of nextState to Y0

always @(*) begin
    case(currentState)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule