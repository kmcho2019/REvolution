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

reg [2:0] current_state; // current state
reg [2:0] next_state; // next state
reg clk_enable; // clock enable signal for clock gating

// Clock gating logic
always @(*) begin
    case (current_state)
        3'b000: clk_enable = (x == 1'b1);
        3'b001: clk_enable = (x == 1'b1);
        3'b010: clk_enable = (x == 1'b1);
        3'b011: clk_enable = (x == 1'b1);
        3'b100: clk_enable = (x == 1'b1);
        default: clk_enable = 1'b0;
    endcase
end

NextStateModule next_state_module(
  .y(current_state),
  .x(x),
  .next_y(next_state)
);

OutputModule output_module(
  .y(current_state),
  .z(z)
);

always @(posedge clk) begin
    if (reset) begin
        current_state <= 3'b000; // synchronous active high reset
    end else if (clk_enable) begin
        current_state <= next_state;
    end
end

endmodule