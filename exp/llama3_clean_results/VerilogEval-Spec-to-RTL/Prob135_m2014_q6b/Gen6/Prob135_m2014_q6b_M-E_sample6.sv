module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

// Define state codes as parameters for clarity and maintainability
parameter STATE_A = 3'b000;
parameter STATE_B = 3'b001;
parameter STATE_C = 3'b010;
parameter STATE_D = 3'b011;
parameter STATE_E = 3'b100;
parameter STATE_F = 3'b101;

// Use a case statement to simplify the next-state logic for y[1]
always @(*) begin
    case (y)
        STATE_A: Y1 = 1'b0;
        STATE_B: Y1 = 1'b1;
        STATE_C: Y1 = 1'b1;
        STATE_D: Y1 = (w) ? 1'b0 : 1'b0;
        STATE_E: Y1 = 1'b1;
        STATE_F: Y1 = (w) ? 1'b1 : 1'b0;
        default: Y1 = 1'b0; // Default case for invalid states
    endcase
end

endmodule