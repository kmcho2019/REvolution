module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y;  // Current state

always @ (posedge clk) begin
    if (reset) begin  // Synchronous active high reset
        y <= 3'b000;  // Reset to state 000
    end else begin
        case (y)
            3'b000: y <= x ? 3'b001 : 3'b000;
            3'b001: y <= x ? 3'b100 : 3'b001;
            3'b010: y <= x ? 3'b001 : 3'b010;
            3'b011: y <= x ? 3'b010 : 3'b001;
            3'b100: y <= x ? 3'b100 : 3'b011;
            default: y <= 3'b000;  // Handle unknown states
        endcase
    end
end

always @ (*) begin  // Determine output z
    case (y)
        3'b000, 3'b001, 3'b010: z = 1'b0;
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0;  // Handle unknown states
    endcase
end

endmodule