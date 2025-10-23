module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state

// next state logic
always @(*) begin
    case (y)
        3'b000: y = x ? 3'b001 : 3'b000;
        3'b001: y = x ? 3'b100 : 3'b001;
        3'b010: y = x ? 3'b001 : 3'b010;
        3'b011: y = x ? 3'b010 : 3'b001;
        3'b100: y = x ? 3'b100 : 3'b011;
        default: y = 3'b000;
    endcase
end

// sequential logic and output logic combined
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
        z <= 1'b0;
    end else begin
        // Update y
        case (y)
            3'b000: y <= x ? 3'b001 : 3'b000;
            3'b001: y <= x ? 3'b100 : 3'b001;
            3'b010: y <= x ? 3'b001 : 3'b010;
            3'b011: y <= x ? 3'b010 : 3'b001;
            3'b100: y <= x ? 3'b100 : 3'b011;
            default: y <= 3'b000;
        endcase

        // Update z
        case (y)
            3'b011: z <= 1'b1;
            3'b100: z <= 1'b1;
            default: z <= 1'b0;
        endcase
    end
end

endmodule