module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output reg Y0,
    output reg z
);

reg [2:0] currentState;
reg [2:0] nextState;

// Reset signal
input reset;

always @(posedge clk) begin
    if (reset) begin
        currentState <= 3'b000;
    end else begin
        currentState <= nextState;
    end
    Y0 <= currentState[0];
    z <= (currentState == 3'b011) || (currentState == 3'b100);
end

always @(*) begin
    case (currentState)
        3'b000: begin
            if (!x) begin
                nextState = 3'b000;
            end else begin
                nextState = 3'b001;
            end
        end
        3'b001: begin
            if (!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b100;
            end
        end
        3'b010: begin
            if (!x) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b001;
            end
        end
        3'b011: begin
            if (!x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b010;
            end
        end
        3'b100: begin
            if (!x) begin
                nextState = 3'b011;
            end else begin
                nextState = 3'b100;
            end
        end
        default: begin
            nextState = 3'b000;
        end
    endcase
end

endmodule