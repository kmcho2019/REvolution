module NextStateModule(
    input [2:0] y,
    input x,
    output reg [2:0] next_y
);

always_comb begin
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

always_comb begin
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

NextStateModule next_state_module(
   .y(y),
   .x(x),
   .next_y(next_y)
);

OutputModule output_module(
   .y(y),
   .z(z)
);

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        y <= next_y;
    end
end

// Simplified clock gating
reg clock_enable;
always_comb begin
    clock_enable = (y != next_y);
end

// Clock gate the state register
always @(posedge clk) begin
    if (clock_enable) begin
        y <= next_y;
    end
end

endmodule