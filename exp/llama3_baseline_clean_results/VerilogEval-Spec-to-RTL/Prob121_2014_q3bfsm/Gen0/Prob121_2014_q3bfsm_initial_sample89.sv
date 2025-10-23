module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y, next_y;

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        y <= next_y;
    end
end

always @(*) begin
    case (y)
        3'b000: next_y = (x == 0) ? 3'b000 : 3'b001;
        3'b001: next_y = (x == 0) ? 3'b001 : 3'b100;
        3'b010: next_y = (x == 0) ? 3'b010 : 3'b001;
        3'b011: next_y = (x == 0) ? 3'b001 : 3'b010;
        3'b100: next_y = (x == 0) ? 3'b011 : 3'b100;
        default: next_y = 3'b000; // Default to state 000 for any other state
    endcase

    case (y)
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule