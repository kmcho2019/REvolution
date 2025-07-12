module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    wire next_y1;
    always @(*) begin
        case (y)
            3'b000: next_y1 = ~w;
            3'b001: next_y1 = w;
            3'b010: next_y1 = w;
            3'b011: next_y1 = ~w;
            3'b100: next_y1 = w;
            3'b101: next_y1 = w;
            default: next_y1 = 0;
        endcase
    end

    assign Y1 = next_y1;
endmodule