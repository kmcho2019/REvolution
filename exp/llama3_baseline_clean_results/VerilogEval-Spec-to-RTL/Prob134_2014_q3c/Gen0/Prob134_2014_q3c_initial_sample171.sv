module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] nextState;
reg [2:0] currentState;

always @(posedge clk) begin
    currentState <= nextState;
end

always @(*) begin
    case (currentState)
        3'b000: nextState = x ? 3'b001 : 3'b000;
        3'b001: nextState = x ? 3'b100 : 3'b001;
        3'b010: nextState = x ? 3'b001 : 3'b010;
        3'b011: nextState = x ? 3'b010 : 3'b001;
        3'b100: nextState = x ? 3'b100 : 3'b011;
        default: nextState = currentState; // Stay in the same state for unspecified cases
    endcase
end

always @(*) begin
    case (currentState)
        3'b000, 3'b001, 3'b010: z = 0;
        3'b011, 3'b100: z = 1;
        default: z = 0; // Default output for unspecified states
    endcase
end

assign Y0 = (x ? (currentState == 3'b000 ? 1'b1 : (currentState == 3'b001 ? 1'b0 : (currentState == 3'b010 ? 1'b1 : (currentState == 3'b011 ? 1'b0 : (currentState == 3'b100 ? 1'b0 : 1'b0))))) : (currentState == 3'b000 ? 1'b0 : (currentState == 3'b001 ? 1'b0 : (currentState == 3'b010 ? 1'b0 : (currentState == 3'b011 ? 1'b0 : (currentState == 3'b100 ? 1'b1 : 1'b0))))));

// Correct implementation based on nextState
always @(*) begin
    case (currentState)
        3'b000: Y0 = x ? 3'b001[0] : 3'b000[0];
        3'b001: Y0 = x ? 3'b100[0] : 3'b001[0];
        3'b010: Y0 = x ? 3'b001[0] : 3'b010[0];
        3'b011: Y0 = x ? 3'b010[0] : 3'b001[0];
        3'b100: Y0 = x ? 3'b100[0] : 3'b011[0];
        default: Y0 = currentState[0]; // Default for unspecified cases
    endcase
end

endmodule