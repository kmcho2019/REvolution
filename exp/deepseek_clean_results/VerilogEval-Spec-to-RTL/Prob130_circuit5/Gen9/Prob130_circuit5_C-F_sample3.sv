module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Detect when c >= 4 (output should be 'f')
wire output_f = |c[3:2];

// 4:1 mux for valid cases (c < 4)
wire [3:0] mux_out;
assign mux_out = (c[1:0] == 2'b00) ? b :
                 (c[1:0] == 2'b01) ? e :
                 (c[1:0] == 2'b10) ? a :
                 d;

// Final output - mux result unless c >= 4, then 'f'
assign q = output_f ? 4'b1111 : mux_out;

endmodule