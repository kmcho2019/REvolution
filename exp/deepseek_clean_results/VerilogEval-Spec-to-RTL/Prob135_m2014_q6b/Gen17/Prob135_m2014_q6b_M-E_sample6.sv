module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // LUT-based next-state logic for y[1]
    reg next_y1;
    always @(*) begin
        // LUT entries for states A-F (y=000 to 101)
        // Format: {state_A_logic, state_B_logic, ..., state_F_logic}
        // Each state logic is either constant or w-dependent
        next_y1 = (y == 3'b000) ? 1'b0 :         // State A
                  (y == 3'b001) ? 1'b1 :         // State B (always 1)
                  (y == 3'b010) ? w :            // State C
                  (y == 3'b011) ? 1'b0 :         // State D (always 0)
                  (y == 3'b100) ? 1'b1 :         // State E
                  (y == 3'b101) ? w : 1'b0;      // State F or default
    end

endmodule