module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    wire [3:0] mux_out;

    // Use a 4-to-1 MUX with c[1:0] as the select input
    assign mux_out = (c[1:0] == 2'b00) ? b :
                     (c[1:0] == 2'b01) ? e :
                     (c[1:0] == 2'b10) ? a :
                     (c[1:0] == 2'b11) ? d : 4'b0000;

    // Assign mux_out to q if c[3:2] is 2'b00, otherwise assign all ones
    assign q = (c[3:2] == 2'b00) ? mux_out : 4'b1111;

endmodule