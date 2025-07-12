module TopModule(
    input clk,
    input w,
    output reg Y1
);

    reg [2:0] y;

    always @(posedge clk) begin
        case (y)
            3'b000: y <= (w == 1'b0)? 3'b001 : 3'b000; // State A transitions
            3'b001: y <= (w == 1'b0)? 3'b010 : 3'b011; // State B transitions
            3'b010: y <= (w == 1'b0)? 3'b100 : 3'b011; // State C transitions
            3'b011: y <= (w == 1'b0)? 3'b101 : 3'b000; // State D transitions
            3'b100: y <= (w == 1'b0)? 3'b100 : 3'b011; // State E transitions
            3'b101: y <= (w == 1'b0)? 3'b010 : 3'b011; // State F transitions
            default: y <= 3'b000;
        endcase
    end

    assign Y1 = y[1];

endmodule