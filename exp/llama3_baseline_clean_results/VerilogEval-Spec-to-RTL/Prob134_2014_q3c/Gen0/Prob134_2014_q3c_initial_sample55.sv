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
    case(currentState)
        3'b000: begin
            if (!x) begin
                nextState = 3'b000;
            end else begin
                nextState = 3'b001;
            end
            z = 0;
        end
        3'b001: begin
            if (!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b100;
            end
            z = 0;
        end
        3'b010: begin
            if (!x) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b001;
            end
            z = 0;
        end
        3'b011: begin
            if (!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b010;
            end
            z = 1;
        end
        3'b100: begin
            if (!x) begin
                nextState = 3'b011;
            end else begin
                nextState = 3'b100;
            end
            z = 1;
        end
        default: begin
            nextState = 3'b000; // Default next state
            z = 0; // Default output
        end
    endcase
    Y0 = nextState[0];
end

endmodule