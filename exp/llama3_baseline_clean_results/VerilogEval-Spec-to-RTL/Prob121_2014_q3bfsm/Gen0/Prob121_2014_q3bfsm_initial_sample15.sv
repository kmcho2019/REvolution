module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

always @(*) begin
    case (y)
        3'b000: next_y = x ? 3'b001 : 3'b000;
        3'b001: next_y = x ? 3'b100 : 3'b001;
        3'b010: next_y = x ? 3'b001 : 3'b010;
        3'b011: next_y = x ? 3'b010 : 3'b001;
        3'b100: next_y = x ? 3'b100 : 3'b011;
        default: next_y = 3'b000; // don't care condition, reset to 000
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        y <= next_y;
    end
end

always @(*) begin
    case (y)
        3'b000, 3'b001, 3'b010: z = 1'b0;
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0; // don't care condition, output 0
    endcase
end

endmodule