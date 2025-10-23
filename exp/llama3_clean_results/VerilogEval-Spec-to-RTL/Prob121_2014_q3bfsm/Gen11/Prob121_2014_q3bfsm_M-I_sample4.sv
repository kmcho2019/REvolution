module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [1:0] y; // current state (using 2 bits instead of 3)
reg [1:0] next_y; // next state

always @(*) begin
    case (y)
        2'b00: next_y = x? 2'b01 : 2'b00;
        2'b01: next_y = x? 2'b10 : 2'b01;
        2'b10: next_y = x? 2'b01 : 2'b10;
        default: next_y = x? 2'b10 : 2'b01;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        y <= 2'b00; // synchronous active high reset
    end else begin
        y <= next_y;
    end
end

always @(*) begin
    case (y)
        2'b10: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule