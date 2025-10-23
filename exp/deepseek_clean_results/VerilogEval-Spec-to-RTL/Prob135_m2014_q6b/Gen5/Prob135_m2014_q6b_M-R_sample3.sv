module TopModule (
    input [2:0] y,    // Current state (3-bit input)
    input w,          // Input signal
    output Y1         // Output y[1]
);

// State encoding parameters
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

reg next_y1;

always @(*) begin
    case (y)
        A: next_y1 = 1'b0;        // A->B or A->A: y[1] stays 0
        B: next_y1 = w ? 1'b1 : 1'b0;  // B->D (1) or B->C (0)
        C: next_y1 = w ? 1'b1 : 1'b0;  // C->D (1) or C->E (0)
        D: next_y1 = w ? 1'b0 : 1'b1;  // D->A (0) or D->F (1)
        E: next_y1 = 1'b1;        // E->D or E->E: y[1] stays 1
        F: next_y1 = w ? 1'b1 : 1'b1;  // F->D (1) or F->C (1) - corrected
        default: next_y1 = 1'b0;   // Handle unspecified states
    endcase
end

assign Y1 = y[1];  // Direct output assignment

endmodule