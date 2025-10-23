module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// Lookup table for next state logic
always @(*) begin
    case (y)
        3'b000: next_y = x? 3'b001 : 3'b000;
        3'b001: next_y = x? 3'b100 : 3'b001;
        3'b010: next_y = x? 3'b001 : 3'b010;
        3'b011: next_y = x? 3'b010 : 3'b001;
        3'b100: next_y = x? 3'b100 : 3'b011;
        default: next_y = 3'b000;
    endcase
end

// Direct computation for output logic
assign z = (y == 3'b011) || (y == 3'b100);

// Sequential logic with clock gating
reg clk_enable;
assign clk_enable = ~reset;

always @(posedge clk) begin
    if (clk_enable) begin
        if (reset) begin
            y <= 3'b000; // synchronous active high reset
        end else begin
            y <= next_y;
        end
    end
end

endmodule