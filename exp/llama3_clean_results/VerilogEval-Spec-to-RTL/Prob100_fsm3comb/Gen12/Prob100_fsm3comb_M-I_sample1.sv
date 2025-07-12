module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

reg [1:0] next_state_reg;

always @(*) begin
    case (state)
        2'b00: next_state_reg = (in)? 2'b01 : 2'b00;
        2'b01: next_state_reg = (in)? 2'b01 : 2'b10;
        2'b10: next_state_reg = (in)? 2'b11 : 2'b00;
        2'b11: next_state_reg = (in)? 2'b01 : 2'b10;
        default: next_state_reg = 2'b00;
    endcase
end

assign next_state = next_state_reg;
assign out = (state == 2'b11);

endmodule