module TopModule(
    input  in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

wire [1:0] ns_A, ns_B, ns_C, ns_D;

assign ns_A = (in)? 2'b01 : 2'b00;
assign ns_B = (in)? 2'b01 : 2'b10;
assign ns_C = (in)? 2'b11 : 2'b00;
assign ns_D = (in)? 2'b01 : 2'b10;

assign next_state = (state == 2'b00)? ns_A :
                     (state == 2'b01)? ns_B :
                     (state == 2'b10)? ns_C :
                     (state == 2'b11)? ns_D : 2'b00;

assign out = (state == 2'b11);

endmodule