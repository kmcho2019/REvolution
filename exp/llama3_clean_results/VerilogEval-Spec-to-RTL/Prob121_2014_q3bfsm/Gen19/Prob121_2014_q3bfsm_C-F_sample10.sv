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
reg clk_en; // clock enable signal

NextStateModule next_state_module(
   .y(y),
   .x(x),
   .next_y(next_y)
);

OutputModule output_module(
   .y(y),
   .z(z)
);

// Clock gating logic to reduce power consumption
always @(*) begin
    case (y)
        3'b000: clk_en = (x == 0)? 1'b0 : 1'b1;
        3'b001: clk_en = (x == 0)? 1'b0 : 1'b1;
        3'b010: clk_en = (x == 0)? 1'b0 : 1'b1;
        3'b011: clk_en = (x == 0)? 1'b0 : 1'b1;
        3'b100: clk_en = (x == 0)? 1'b0 : 1'b1;
        default: clk_en = 1'b0;
    endcase
end

// Use clock enable for state register
always @(posedge clk) begin
    if (clk_en || reset) begin
        if (reset) begin
            y <= 3'b000; // synchronous active high reset
        end else begin
            y <= next_y;
        end
    end
end

// Consider adding more advanced power management techniques here
// such as dynamic voltage scaling or more sophisticated clock gating

endmodule