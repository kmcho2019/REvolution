module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        case (y)
            3'b000: y <= x ? 3'b001 : 3'b000;
            3'b001: y <= x ? 3'b100 : 3'b001;
            3'b010: y <= x ? 3'b001 : 3'b010;
            3'b011: y <= x ? 3'b010 : 3'b001;
            3'b100: y <= x ? 3'b100 : 3'b011;
            default: y <= 3'b000;
        endcase
    end
    // Directly derive z from the current state
    z <= (y == 3'b011) || (y == 3'b100);
end

endmodule