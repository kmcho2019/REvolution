module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;

reg [2:0] currentState;
reg [2:0] nextState;

always @(posedge clk) begin
    if (reset) begin
        currentState <= S000;
    end else begin
        currentState <= nextState;
    end
end

always @(*) begin
    case (currentState)
        S000: nextState = x ? S001 : S000;
        S001: nextState = x ? S100 : S001;
        S010: nextState = x ? S001 : S010;
        S011: nextState = x ? S010 : S001;
        S100: nextState = x ? S100 : S011;
        default: nextState = S000; // default state
    endcase
end

always @(*) begin
    case (currentState)
        S000, S001, S010: z = 0;
        S011, S100: z = 1;
        default: z = 0; // default output
    endcase
end

endmodule