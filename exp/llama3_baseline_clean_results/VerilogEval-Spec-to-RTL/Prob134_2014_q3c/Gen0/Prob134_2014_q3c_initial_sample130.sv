module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] currentState;
reg [2:0] nextState;

always @(*) begin
    case (currentState)
        3'b000: nextState = x ? 3'b001 : 3'b000;
        3'b001: nextState = x ? 3'b100 : 3'b001;
        3'b010: nextState = x ? 3'b001 : 3'b010;
        3'b011: nextState = x ? 3'b010 : 3'b001;
        3'b100: nextState = x ? 3'b100 : 3'b011;
        default: nextState = 3'b000;
    endcase
end

always @(posedge clk) begin
    currentState <= nextState;
end

assign z = (currentState == 3'b011 || currentState == 3'b100);
assign Y0 = nextState[0];

endmodule