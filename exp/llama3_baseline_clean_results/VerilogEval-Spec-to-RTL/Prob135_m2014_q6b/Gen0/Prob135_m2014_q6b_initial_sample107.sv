module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

reg [2:0] nextState;
reg [2:0] currentState;

always @(posedge w) begin
    case (y)
        3'b000: begin  // State A
            if (!w) begin
                nextState = 3'b001;  // Next state B
            end else begin
                nextState = 3'b000;  // Next state A
            end
        end
        3'b001: begin  // State B
            if (!w) begin
                nextState = 3'b010;  // Next state C
            end else begin
                nextState = 3'b100;  // Next state D
            end
        end
        3'b010: begin  // State C
            if (!w) begin
                nextState = 3'b101;  // Next state E
            end else begin
                nextState = 3'b100;  // Next state D
            end
        end
        3'b011: begin  // State D
            if (!w) begin
                nextState = 3'b011;  // Next state D
            end else begin
                nextState = 3'b000;  // Next state A
            end
        end
        3'b100: begin  // State E
            if (w) begin
                nextState = 3'b100;  // Next state E
            end else begin
                nextState = 3'b100;  // Next state E
            end
        end
        3'b101: begin  // State F
            if (w) begin
                nextState = 3'b010;  // Next state C
            end else begin
                nextState = 3'b100;  // Next state D
            end
        end
    endcase
    currentState = nextState;
end

assign Y1 = currentState[1];  // Assign the value of y[1] to the output Y1

endmodule