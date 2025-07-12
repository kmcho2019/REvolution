module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] y_next;

always @(*) begin
    case(y)
        3'b000: y_next = (x == 0) ? 3'b000 : 3'b001;
        3'b001: y_next = (x == 0) ? 3'b001 : 3'b100;
        3'b010: y_next = (x == 0) ? 3'b010 : 3'b001;
        3'b011: y_next = (x == 0) ? 3'b001 : 3'b010;
        3'b100: y_next = (x == 0) ? 3'b011 : 3'b100;
        default: y_next = 3'b000; // default state
    endcase
end

always @(posedge clk) begin
    y <= y_next;
end

assign Y0 = y_next[0];
assign z = (y == 3'b011 || y == 3'b100);

endmodule