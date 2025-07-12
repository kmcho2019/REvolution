module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        case (y)
            3'b000: next_y = x ? 3'b001 : 3'b000;
            3'b001: next_y = x ? 3'b100 : 3'b001;
            3'b010: next_y = x ? 3'b001 : 3'b010;
            3'b011: next_y = x ? 3'b010 : 3'b001;
            3'b100: next_y = x ? 3'b100 : 3'b011;
            default: next_y = 3'b000;
        endcase
        y <= next_y;
        z = (y == 3'b011 || y == 3'b100) ? 1'b1 : 1'b0;
    end
end

endmodule