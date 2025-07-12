module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

always @(*) begin
    case (y)
        3'b000: next_y = x? 3'b001 : 3'b000;
        3'b001: next_y = x? 3'b100 : 3'b001;
        3'b010: next_y = x? 3'b001 : 3'b010;
        3'b011: next_y = x? 3'b010 : 3'b001;
        3'b100: next_y = x? 3'b100 : 3'b011;
        default: next_y = 3'b000;
    endcase
    
    case (y)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        y <= next_y;
    end
end

// Simplified clock gating to disable clock when FSM is in a stable state
reg clock_enable;
always @(*) begin
    case (y)
        3'b000: clock_enable = (x == 0)? 1'b0 : 1'b1;
        3'b001: clock_enable = (x == 0)? 1'b0 : 1'b1;
        3'b010: clock_enable = (x == 0)? 1'b0 : 1'b1;
        3'b011: clock_enable = (x == 0)? 1'b0 : 1'b1;
        3'b100: clock_enable = (x == 0)? 1'b0 : 1'b1;
        default: clock_enable = 1'b0;
    endcase
end

endmodule