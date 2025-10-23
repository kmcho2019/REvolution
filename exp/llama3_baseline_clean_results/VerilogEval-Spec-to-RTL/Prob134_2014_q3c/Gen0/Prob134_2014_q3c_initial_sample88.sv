module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] currentState;
reg [2:0] nextState;

// Combinational logic for next state
always @(*) begin
    case (currentState)
        3'b000: nextState = x ? 3'b001 : 3'b000;
        3'b001: nextState = x ? 3'b100 : 3'b001;
        3'b010: nextState = x ? 3'b001 : 3'b010;
        3'b011: nextState = x ? 3'b010 : 3'b001;
        3'b100: nextState = x ? 3'b100 : 3'b011;
        default: nextState = currentState; // Unspecified states transition to themselves
    endcase
end

// Combinational logic for output z
always @(*) begin
    case (currentState)
        3'b000, 3'b001, 3'b010: z = 0;
        3'b011, 3'b100: z = 1;
        default: z = 0; // Unspecified states default to output 0
    endcase
end

// Sequential logic for state registration
always @(posedge clk) begin
    currentState <= nextState;
end

// Continuous assignment for output Y0
assign Y0 = nextState[0];

endmodule