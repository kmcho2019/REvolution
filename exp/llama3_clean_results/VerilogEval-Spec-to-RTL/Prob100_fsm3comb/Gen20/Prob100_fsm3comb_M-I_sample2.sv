module TopModule(
    input  in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(*) begin
    if (state == 2'b00) next_state = in ? 2'b01 : 2'b00;
    else if (state == 2'b01) next_state = in ? 2'b01 : 2'b10;
    else if (state == 2'b10) next_state = in ? 2'b11 : 2'b00;
    else if (state == 2'b11) next_state = in ? 2'b01 : 2'b10;
    else next_state = 2'b00;
end

assign out = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule