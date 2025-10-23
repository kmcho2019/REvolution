module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] currentState;
reg [2:0] nextState;
reg nextY0;
reg nextZ;

always @(posedge clk) begin
    currentState <= nextState;
    Y0 <= nextY0;
    z <= nextZ;
end

always @(*) begin
    case (currentState)
        3'b000: begin
            if (~x) begin
                nextState = 3'b000;
            end else begin
                nextState = 3'b001;
            end
            nextZ = 1'b0;
        end
        3'b001: begin
            if (~x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b100;
            end
            nextZ = 1'b0;
        end
        3'b010: begin
            if (~x) begin
                nextState = 3'b010;
            end else begin
                nextState = 3'b001;
            end
            nextZ = 1'b0;
        end
        3'b011: begin
            if (~x) begin
                nextState = 3'b001;
            end else begin
                nextState = 3'b010;
            end
            nextZ = 1'b1;
        end
        3'b100: begin
            if (~x) begin
                nextState = 3'b011;
            end else begin
                nextState = 3'b100;
            end
            nextZ = 1'b1;
        end
        default: begin
            nextState = 3'b000;
            nextZ = 1'b0;
        end
    endcase
    nextY0 = nextState[0];
end

initial begin
    currentState = 3'b000;
end

endmodule