module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Simplified next-state logic for y[1]
    reg next_y1;
    always @(*) begin
        next_y1 = y[1];  // Default: maintain current value
        
        case (y)
            3'b001: if (w) next_y1 = 1'b1;  // B->D
            3'b010: if (w) next_y1 = 1'b1;   // C->D
            3'b011: if (!w) next_y1 = 1'b0;  // D->F
            3'b100: if (w) next_y1 = 1'b1;   // E->D
            3'b101: next_y1 = ~w;            // F->C (w=0) or F->D (w=1)
        endcase
    end

endmodule