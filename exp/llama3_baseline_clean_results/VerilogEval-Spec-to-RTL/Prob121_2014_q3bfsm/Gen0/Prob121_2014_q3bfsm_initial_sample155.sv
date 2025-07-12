module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // Current state

always @ (posedge clk) begin
    if (reset) begin // Synchronous active high reset
        y <= 3'b000; // Reset state to 000
    end else begin
        case (y)
            3'b000: y <= (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: y <= (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: y <= (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: y <= (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: y <= (x == 1'b0) ? 3'b011 : 3'b100;
            default: y <= 3'b000; // Default to state 000 for invalid states
        endcase
    end
end

always @ (*) begin
    case (y)
        3'b000: z = 1'b0;
        3'b001: z = 1'b0;
        3'b010: z = 1'b0;
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0; // Default output for invalid states
    endcase
end

endmodule