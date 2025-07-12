module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output reg Y0,
    output reg z
);

reg [2:0] currentState;
reg [2:0] nextState;

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
            nextState = 3'b000; // default next state
        end
    endcase
end

always @(*) begin
    case (currentState)
        3'b000, 3'b001, 3'b010: z = 1'b0;
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0; // default output
    endcase
    Y0 = nextState[0];
end

always @(posedge clk) begin
    currentState <= nextState;
end

endmodule