module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Assign Y1 and Y3 based on the state transitions
always @(*)
begin
    case (1'b1)
        y[0] && w: Y1 = 1'b1; // A -> B
        default: Y1 = 1'b0;
    endcase

    case (1'b1)
        y[1] &&!w: Y3 = 1'b1; // B -> D
        y[2] &&!w: Y3 = 1'b1; // C -> D
        y[3] &&!w: Y3 = 1'b1; // D -> D
        y[4] &&!w: Y3 = 1'b1; // E -> D
        y[5] &&!w: Y3 = 1'b1; // F -> D
        default: Y3 = 1'b0;
    endcase
end

endmodule