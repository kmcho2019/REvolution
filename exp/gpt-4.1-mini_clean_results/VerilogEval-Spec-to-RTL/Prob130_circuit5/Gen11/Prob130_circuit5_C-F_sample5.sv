module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Select inputs for c=0..3
    wire [3:0] mux_out;
    assign mux_out = (c == 4'd0) ? b :
                     (c == 4'd1) ? e :
                     (c == 4'd2) ? a :
                     (c == 4'd3) ? d :
                     4'hF;

    assign q = mux_out;

endmodule