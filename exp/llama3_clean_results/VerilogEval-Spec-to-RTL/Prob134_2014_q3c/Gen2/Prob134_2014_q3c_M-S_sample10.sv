module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;

always @ (posedge clk) begin
    case ({y, x})
        4'b0000: current_state <= 3'b000;
        4'b0001: current_state <= 3'b001;
        4'b0010: current_state <= 3'b001;
        4'b0011: current_state <= 3'b100;
        4'b0100: current_state <= 3'b010;
        4'b0101: current_state <= 3'b001;
        4'b0110: current_state <= 3'b001;
        4'b0111: current_state <= 3'b010;
        4'b1000: current_state <= 3'b011;
        4'b1001: current_state <= 3'b100;
        default: current_state <= 3'b000;
    endcase
end

always @ (*) begin
    case (y)
        3'b000, 3'b001, 3'b010: z = 0;
        3'b011: z = x ? 1 : 0;
        3'b100: z = 1;
        default: z = 0;
    endcase
end

always @ (*) begin
    case ({y, x})
        4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0110, 4'b1000: Y0 = 0;
        4'b0101, 4'b0111, 4'b1001: Y0 = 1;
        default: Y0 = 0;
    endcase
end

endmodule