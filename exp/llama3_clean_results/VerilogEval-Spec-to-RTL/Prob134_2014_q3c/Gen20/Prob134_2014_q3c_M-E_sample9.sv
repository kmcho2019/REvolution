module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] state;

always @ (posedge clk) begin
    case (state)
        3'b000: state <= x? 3'b001 : 3'b000;
        3'b001: state <= x? 3'b100 : 3'b001;
        3'b010: state <= x? 3'b001 : 3'b010;
        3'b011: state <= x? 3'b010 : 3'b001;
        3'b100: state <= x? 3'b100 : 3'b011;
        default: state <= 3'b000;
    endcase
end

assign Y0 = state[0];
assign z = (state == 3'b011) || (state == 3'b100);

endmodule