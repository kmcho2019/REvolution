module TopModule(
    input  in,
    input  [1:0] state,
    output [1:0] next_state,
    output out
);

// Internal signals for next state and output
wire [1:0] ns_A, ns_B, ns_C, ns_D;
wire o_A, o_B, o_C, o_D;

// Next state logic for each state
assign ns_A = (in)? 2'b01 : 2'b00;
assign ns_B = (in)? 2'b01 : 2'b10;
assign ns_C = (in)? 2'b11 : 2'b00;
assign ns_D = (in)? 2'b01 : 2'b10;

// Output logic for each state
assign o_A = 1'b0;
assign o_B = 1'b0;
assign o_C = 1'b0;
assign o_D = 1'b1;

// Decoded next state and output
wire [1:0] ns_decoded;
wire o_decoded;

// 2-to-4 decoder for state
wire s_A, s_B, s_C, s_D;
assign s_A = (state == 2'b00)? 1'b1 : 1'b0;
assign s_B = (state == 2'b01)? 1'b1 : 1'b0;
assign s_C = (state == 2'b10)? 1'b1 : 1'b0;
assign s_D = (state == 2'b11)? 1'b1 : 1'b0;

// Mux for next state
assign ns_decoded = (s_A)? ns_A :
                    (s_B)? ns_B :
                    (s_C)? ns_C :
                    (s_D)? ns_D : 2'b00;

// Mux for output
assign o_decoded = (s_A)? o_A :
                   (s_B)? o_B :
                   (s_C)? o_C :
                   (s_D)? o_D : 1'b0;

// Final assignment of next state and output
assign next_state = ns_decoded;
assign out = o_decoded;

endmodule