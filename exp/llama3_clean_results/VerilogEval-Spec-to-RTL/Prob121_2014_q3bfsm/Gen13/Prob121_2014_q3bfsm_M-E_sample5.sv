module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// State decoding LUT
always @(*) begin
    case (y)
        3'b001: next_y = x ? 3'b100 : 3'b001;
        3'b010: next_y = x ? 3'b001 : 3'b010;
        3'b011: next_y = x ? 3'b010 : 3'b001;
        3'b100: next_y = x ? 3'b100 : 3'b011;
        default: next_y = x ? 3'b001 : 3'b000;
    endcase
end

// Output generation LUT
always @(*) begin
    case (y)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Sequential logic with clock gating
reg clk_enable;
always @(*) begin
    case (y)
        3'b000: clk_enable = x;
        3'b001: clk_enable = x;
        3'b010: clk_enable = ~x;
        3'b011: clk_enable = ~x;
        3'b100: clk_enable = ~x;
        default: clk_enable = 1'b0;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else if (clk_enable) begin
        y <= next_y;
    end
end

endmodule