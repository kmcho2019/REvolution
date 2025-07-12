module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] currentState, nextState;

always @(posedge clk) begin
    currentState <= nextState;
end

always @(*) begin
    case (currentState)
        3'b000: begin
            if (!x) nextState = 3'b000;
            else nextState = 3'b001;
            z = 1'b0;
        end
        3'b001: begin
            if (!x) nextState = 3'b001;
            else nextState = 3'b100;
            z = 1'b0;
        end
        3'b010: begin
            if (!x) nextState = 3'b010;
            else nextState = 3'b001;
            z = 1'b0;
        end
        3'b011: begin
            if (!x) nextState = 3'b001;
            else nextState = 3'b010;
            z = 1'b1;
        end
        3'b100: begin
            if (!x) nextState = 3'b011;
            else nextState = 3'b100;
            z = 1'b1;
        end
        default: begin
            nextState = 3'b000; // Default next state if current state is unknown
            z = 1'b0;
        end
    endcase
    Y0 = nextState[0]; // Y0 is Y[0] of the next state
end

endmodule