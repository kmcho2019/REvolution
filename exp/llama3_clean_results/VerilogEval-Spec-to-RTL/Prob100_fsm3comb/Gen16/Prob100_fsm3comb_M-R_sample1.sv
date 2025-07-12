module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

assign out = (state == 2'b11);

always @(in, state) begin
    case (state)
        2'b00: next_state = in? 2'b01 : 2'b00;
        2'b01: next_state = in? 2'b01 : 2'b10;
        2'b10: next_state = in? 2'b11 : 2'b00;
        2'b11: next_state = in? 2'b01 : 2'b10;
    endcase
end

endmodule