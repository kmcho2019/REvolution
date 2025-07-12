module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y, next_y;
assign z = (y == 3'b011) || (y == 3'b100);

always @(*) begin
    case(y)
        3'b000: next_y = (x == 1'b0) ? 3'b000 : 3'b001;
        3'b001: next_y = (x == 1'b0) ? 3'b001 : 3'b100;
        3'b010: next_y = (x == 1'b0) ? 3'b010 : 3'b001;
        3'b011: next_y = (x == 1'b0) ? 3'b001 : 3'b010;
        3'b100: next_y = (x == 1'b0) ? 3'b011 : 3'b100;
        default: next_y = 3'b000; // All other states transition to 000
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        y <= next_y;
    end
end

endmodule