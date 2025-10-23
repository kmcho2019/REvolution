module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] state, nextState;

always @(*) begin
    case (y)
        3'b000: begin
            nextState = x ? 3'b001 : 3'b000;
            z = 1'b0;
        end
        3'b001: begin
            nextState = x ? 3'b100 : 3'b001;
            z = 1'b0;
        end
        3'b010: begin
            nextState = x ? 3'b001 : 3'b010;
            z = 1'b0;
        end
        3'b011: begin
            nextState = x ? 3'b010 : 3'b001;
            z = 1'b1;
        end
        3'b100: begin
            nextState = x ? 3'b100 : 3'b011;
            z = 1'b1;
        end
        default: begin
            nextState = 3'b000;
            z = 1'b0;
        end
    endcase
    Y0 = nextState[0];
end

always @(posedge clk) begin
    state <= nextState;
end

endmodule