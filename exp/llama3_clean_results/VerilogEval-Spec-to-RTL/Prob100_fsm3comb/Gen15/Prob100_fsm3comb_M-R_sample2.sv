module TopModule(
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(in, state) begin
    case (state)
        2'b00: next_state = in ? 2'b01 : 2'b00;
        2'b01: next_state = in ? 2'b01 : 2'b10;
        2'b10: next_state = in ? 2'b11 : 2'b00;
        2'b11: next_state = in ? 2'b01 : 2'b10;
    endcase
end

always @(state) begin
    case (state)
        2'b00, 2'b01, 2'b10: out = 1'b0;
        2'b11: out = 1'b1;
    endcase
end

endmodule