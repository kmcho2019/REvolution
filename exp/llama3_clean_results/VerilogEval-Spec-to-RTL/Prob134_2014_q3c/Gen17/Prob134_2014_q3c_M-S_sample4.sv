module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] state;

// Sequential logic
always @ (posedge clk) begin
    case (y)
        3'b000: state <= x? 3'b001 : 3'b000;
        3'b001: state <= x? 3'b100 : 3'b001;
        3'b010: state <= x? 3'b001 : 3'b010;
        3'b011: state <= x? 3'b010 : 3'b001;
        3'b100: state <= x? 3'b100 : 3'b011;
        default: state <= 3'b000;
    endcase
end

// Combinational logic for output
always @ (*) begin
    case (y)
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
    Y0 = (x == 1'b0 && y == 3'b000) || (x == 1'b1 && y == 3'b001) || (x == 1'b1 && y == 3'b010) || (x == 1'b1 && y == 3'b100) || (x == 1'b0 && y == 3'b100) || (x == 1'b0 && y == 3'b011);
end

endmodule