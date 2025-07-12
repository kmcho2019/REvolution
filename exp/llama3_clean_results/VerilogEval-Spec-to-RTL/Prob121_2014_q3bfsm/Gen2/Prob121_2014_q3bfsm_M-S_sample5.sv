module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] state;
reg [2:0] nextState;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case (state)
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
    endcase
end

endmodule