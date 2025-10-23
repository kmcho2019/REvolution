module TopModule(
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(*) begin
    case ({in, state})
        3'b000, 3'b001, 3'b010, 3'b011, 3'b100, 3'b101, 3'b110: begin
            out = 1'b0;
            case (state)
                2'b00: next_state = in? 2'b01 : 2'b00;
                2'b01: next_state = in? 2'b01 : 2'b10;
                2'b10: next_state = in? 2'b11 : 2'b00;
                2'b11: next_state = in? 2'b01 : 2'b10;
            endcase
        end
        3'b111: begin
            out = 1'b1;
            next_state = in? 2'b01 : 2'b10;
        end
    endcase
end

endmodule