module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg [2:0] next_state;

    always @(*) begin
        case ({y, w})
            4'b0000: next_state = 3'b001;
            4'b0001: next_state = 3'b000;
            4'b0010: next_state = 3'b010;
            4'b0011: next_state = 3'b011;
            4'b0100: next_state = 3'b100;
            4'b0101: next_state = 3'b011;
            4'b0110: next_state = 3'b101;
            4'b0111: next_state = 3'b000;
            4'b1000: next_state = 3'b100;
            4'b1001: next_state = 3'b011;
            4'b1010: next_state = 3'b010;
            4'b1011: next_state = 3'b011;
            default: next_state = 3'b000;
        endcase
    end

    assign Y1 = next_state[1];

endmodule