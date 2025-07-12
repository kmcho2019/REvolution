module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] nextState;

always @(y, x) begin
    case (y)
        3'b000: begin
            if (x == 0) nextState = 3'b000;
            else nextState = 3'b001;
        end
        3'b001: begin
            if (x == 0) nextState = 3'b001;
            else nextState = 3'b100;
        end
        3'b010: begin
            if (x == 0) nextState = 3'b010;
            else nextState = 3'b001;
        end
        3'b011: begin
            if (x == 0) nextState = 3'b001;
            else nextState = 3'b010;
        end
        3'b100: begin
            if (x == 0) nextState = 3'b011;
            else nextState = 3'b100;
        end
        default: nextState = y; // For states not explicitly defined, stay in the same state
    endcase
end

assign Y0 = nextState[0];

always @(y, x) begin
    case (y)
        3'b000, 3'b001, 3'b010: z = 0;
        3'b011, 3'b100: z = 1;
        default: z = 0; // For states not explicitly defined, set output to 0
    endcase
end

always @(posedge clk) begin
    y <= nextState;
end

endmodule