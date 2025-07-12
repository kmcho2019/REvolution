module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] y_reg;

always @(posedge clk) begin
    case (y_reg)
        3'b000: y_reg <= (x == 1'b0) ? 3'b000 : 3'b001;
        3'b001: y_reg <= (x == 1'b0) ? 3'b001 : 3'b100;
        3'b010: y_reg <= (x == 1'b0) ? 3'b010 : 3'b001;
        3'b011: y_reg <= (x == 1'b0) ? 3'b001 : 3'b010;
        3'b100: y_reg <= (x == 1'b0) ? 3'b011 : 3'b100;
        default: y_reg <= 3'b000; // default state
    endcase
end

assign Y0 = (x == 1'b0) ? y_reg[0] : 
             (y_reg == 3'b000) ? 3'b001[0] :
             (y_reg == 3'b001) ? 3'b100[0] :
             (y_reg == 3'b010) ? 3'b001[0] :
             (y_reg == 3'b011) ? 3'b010[0] :
             (y_reg == 3'b100) ? 3'b100[0] : 1'b0;

assign z = (y_reg == 3'b011 || y_reg == 3'b100);

endmodule