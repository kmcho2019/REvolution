module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

reg [2:0] currentState;
reg [2:0] nextState;
reg zReg;

always @(*) begin
    case(currentState)
        3'b000: nextState = (x == 1'b0) ? 3'b000 : 3'b001;
        3'b001: nextState = (x == 1'b0) ? 3'b001 : 3'b100;
        3'b010: nextState = (x == 1'b0) ? 3'b010 : 3'b001;
        3'b011: nextState = (x == 1'b0) ? 3'b001 : 3'b010;
        3'b100: nextState = (x == 1'b0) ? 3'b011 : 3'b100;
        default: nextState = 3'b000; // default to state 000 for any other state
    endcase
    
    case(currentState)
        3'b011: zReg = 1'b1;
        3'b100: zReg = 1'b1;
        default: zReg = 1'b0;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        currentState <= 3'b000;
    end else begin
        currentState <= nextState;
    end
    z <= zReg;
end

endmodule