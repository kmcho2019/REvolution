module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] nextState;

always @(y or x) begin
    case (y)
        3'b000: begin
            if (!x) nextState = 3'b000;
            else    nextState = 3'b001;
            z = 0;
        end
        3'b001: begin
            if (!x) nextState = 3'b001;
            else    nextState = 3'b100;
            z = 0;
        end
        3'b010: begin
            if (!x) nextState = 3'b010;
            else    nextState = 3'b001;
            z = 0;
        end
        3'b011: begin
            if (!x) nextState = 3'b001;
            else    nextState = 3'b010;
            z = 1;
        end
        3'b100: begin
            if (!x) nextState = 3'b011;
            else    nextState = 3'b100;
            z = 1;
        end
        default: begin
            nextState = 3'b000;
            z = 0;
        end
    endcase
    Y0 = nextState[0];
end

reg [2:0] currentState;
always @(posedge clk) begin
    currentState <= nextState;
end

assign y = currentState;

endmodule