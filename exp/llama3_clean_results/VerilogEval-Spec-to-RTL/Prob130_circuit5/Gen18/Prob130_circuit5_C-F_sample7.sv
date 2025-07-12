module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

// Select signals based on c[1:0]
wire sel_b = (c[1:0] == 2'b00) ? 1'b1 : 1'b0;
wire sel_e = (c[1:0] == 2'b01) ? 1'b1 : 1'b0;
wire sel_a = (c[1:0] == 2'b10) ? 1'b1 : 1'b0;
wire sel_d = (c[1:0] == 2'b11) ? 1'b1 : 1'b0;

// Multiplexer logic
wire [3:0] q_mux = (sel_b ? b : 4'b0000) | (sel_e ? e : 4'b0000) | (sel_a ? a : 4'b0000) | (sel_d ? d : 4'b0000);

// Override output if c[3:2] != 2'b00
assign q = (c[3:2] != 2'b00) ? 4'd15 : q_mux;

endmodule