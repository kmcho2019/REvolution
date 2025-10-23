module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// State transition logic simplified by input condition
assign next_state = (in == 1'b0) ? (
    (state == 2'b00) ? 2'b00 :
    (state == 2'b01) ? 2'b10 :
    (state == 2'b10) ? 2'b00 :
    (state == 2'b11) ? 2'b10 : 2'b00
) : (
    (state == 2'b00) ? 2'b01 :
    (state == 2'b01) ? 2'b01 :
    (state == 2'b10) ? 2'b11 :
    (state == 2'b11) ? 2'b01 : 2'b00
);

// Output logic remains straightforward
assign out = (state == 2'b11) ? 1'b1 : 1'b0;

endmodule