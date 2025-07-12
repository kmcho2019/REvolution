module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

reg [2:0] y;
reg [2:0] next_y;
reg z_reg;

always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
        z_reg <= 0;
    end else begin
        y <= next_y;
        z_reg <= (y == 3'b011 || y == 3'b100) ? 1 : 0;
    end
end

always @(*) begin
    case(y)
        3'b000: next_y = x ? 3'b001 : 3'b000;
        3'b001: next_y = x ? 3'b100 : 3'b001;
        3'b010: next_y = x ? 3'b001 : 3'b010;
        3'b011: next_y = x ? 3'b010 : 3'b001;
        3'b100: next_y = x ? 3'b100 : 3'b011;
        default: next_y = 3'b000; // default to state 000 if current state is not defined
    endcase
end

assign z = z_reg;

endmodule