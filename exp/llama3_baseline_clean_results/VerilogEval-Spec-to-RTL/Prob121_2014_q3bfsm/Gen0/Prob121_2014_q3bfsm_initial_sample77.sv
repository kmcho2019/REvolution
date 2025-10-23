module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

reg [2:0] y, y_next;
assign z = (y == 3'b011 || y == 3'b100);

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        y <= y_next;
    end
end

always @(*) begin
    case (y)
        3'b000: y_next = x ? 3'b001 : 3'b000;
        3'b001: y_next = x ? 3'b100 : 3'b001;
        3'b010: y_next = x ? 3'b001 : 3'b010;
        3'b011: y_next = x ? 3'b010 : 3'b001;
        3'b100: y_next = x ? 3'b100 : 3'b011;
        default: y_next = 3'b000;
    endcase
end

endmodule