module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    always @(*) begin
        case (y)
            3'b000: Y1 = ~w ? 0 : 0;
            3'b001: Y1 = ~w ? 0 : 1;
            3'b010: Y1 = ~w ? 0 : 1;
            3'b011: Y1 = ~w ? 1 : 0;
            3'b100: Y1 = ~w ? 0 : 1;
            3'b101: Y1 = ~w ? 0 : 1;
            default: Y1 = 0;
        endcase
    end

endmodule