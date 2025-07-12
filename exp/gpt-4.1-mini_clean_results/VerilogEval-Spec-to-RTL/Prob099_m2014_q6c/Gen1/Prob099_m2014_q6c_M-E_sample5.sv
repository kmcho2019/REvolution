module TopModule (
    input  [5:0] y,   // One-hot current state
    input        w,
    output       Y2,  // Next state bit for B (y[1])
    output       Y4   // Next state bit for D (y[3])
);

reg [5:0] next_y;

always @(*) begin
    casez(y)
        6'b000001: // A (y[0])
            if (w == 1'b0)
                next_y = 6'b000010; // B
            else
                next_y = 6'b000001; // A
        6'b000010: // B (y[1])
            if (w == 1'b0)
                next_y = 6'b000100; // C
            else
                next_y = 6'b001000; // D
        6'b000100: // C (y[2])
            if (w == 1'b0)
                next_y = 6'b010000; // E
            else
                next_y = 6'b001000; // D
        6'b001000: // D (y[3])
            if (w == 1'b0)
                next_y = 6'b100000; // F
            else
                next_y = 6'b000001; // A
        6'b010000: // E (y[4])
            if (w == 1'b0)
                next_y = 6'b010000; // E
            else
                next_y = 6'b001000; // D
        6'b100000: // F (y[5])
            if (w == 1'b0)
                next_y = 6'b000100; // C
            else
                next_y = 6'b001000; // D
        default:
            next_y = 6'b000001; // default to A on invalid state
    endcase
end

// Output next state bits for B and D
assign Y2 = next_y[1];
assign Y4 = next_y[3];

endmodule