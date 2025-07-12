module NextStateModule(
    input [2:0] y,
    input x,
    output reg [2:0] next_y
);

always @(*) begin
    case (y)
        3'b000: next_y = x ? 3'b001 : 3'b000;
        3'b001: next_y = x ? 3'b100 : 3'b001;
        3'b010: next_y = x ? 3'b001 : 3'b010;
        3'b011: next_y = x ? 3'b010 : 3'b001;
        3'b100: next_y = x ? 3'b100 : 3'b011;
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
reg clock_enable; // clock enable signal for clock gating

// clock gating logic
always @(*) begin
    if (reset || (y == 3'b000 && x == 1'b0) || (y == 3'b001 && x == 1'b0) || (y == 3'b010 && x == 1'b0)) begin
        clock_enable = 1'b0; // disable clock when state machine is in a stable state
    end else begin
        clock_enable = 1'b1;
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

// pipelined state register with clock gating
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else if (clock_enable) begin
        y <= next_y;
    end
end

endmodule