module TopModule (
    input [2:0] a,
    output [15:0] q
);

assign q =
    case (a)
        3'd0: 16'h1232;
        3'd1: 16'haee0;
        3'd2: 16'h27d4;
        3'd3: 16'h5a0e;
        3'd4: 16'h2066;
        3'd5: 16'h64ce;
        3'd6: 16'hc526;
        3'd7: 16'h2f19;
    endcase

endmodule