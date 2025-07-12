module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] Y;
reg [2:0] nextState;

always @(*) begin
    case (y)
        3'b000: nextState = (x) ? 3'b001 : 3'b000;
        3'b001: nextState = (x) ? 3'b100 : 3'b001;
        3'b010: nextState = (x) ? 3'b001 : 3'b010;
        3'b011: nextState = (x) ? 3'b010 : 3'b001;
        3'b100: nextState = (x) ? 3'b100 : 3'b011;
        default: nextState = 3'b000;
    endcase
end

always @(posedge clk) begin
    Y <= nextState;
end

assign Y0 = Y[0];
assign z = (y == 3'b011 || y == 3'b100 || (y == 3'b100 && x == 0));

endmodule