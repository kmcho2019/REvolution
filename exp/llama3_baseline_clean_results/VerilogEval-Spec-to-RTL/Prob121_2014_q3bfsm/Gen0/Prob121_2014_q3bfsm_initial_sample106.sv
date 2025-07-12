module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // state register

always @ (posedge clk) begin
    if (reset) begin // synchronous active high reset
        y <= 3'b000;
    end else begin
        case (y)
            3'b000: y <= (x == 0) ? 3'b000 : 3'b001;
            3'b001: y <= (x == 0) ? 3'b001 : 3'b100;
            3'b010: y <= (x == 0) ? 3'b010 : 3'b001;
            3'b011: y <= (x == 0) ? 3'b001 : 3'b010;
            3'b100: y <= (x == 0) ? 3'b011 : 3'b100;
            default: y <= 3'b000; // default to initial state if state is unknown
        endcase
    end
end

always @ (*) begin
    case (y)
        3'b000, 3'b001, 3'b010: z = 0;
        3'b011, 3'b100: z = 1;
        default: z = 0; // default output if state is unknown
    endcase
end

endmodule