// Superior solution with fused ideas
module NextStateModule(
    input [2:0] y,
    input x,
    output reg [2:0] next_y
);

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

endmodule

module OutputModule(
    input [2:0] y,
    output reg z
);

always @(*) begin
    case (y)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule

module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state
reg clk_enable; // Clock enable signal

// Clock gating logic
always @(*) begin
    if (y == next_y) begin
        clk_enable = 1'b0; // Disable clock if state doesn't change
    end else begin
        clk_enable = 1'b1; // Enable clock if state changes
    end
end

NextStateModule next_state_module(
  .y(y),
  .x(x),
  .next_y(next_y)
);

OutputModule output_module(
  .y(y),
  .z(z)
);

// Use clock enable for clock gating
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else if (clk_enable) begin
        y <= next_y;
    end
end

endmodule