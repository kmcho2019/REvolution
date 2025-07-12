module TopModule (
    input [2:0] a,
    output reg [15:0] q
);

always @(*) begin
    case (a)
        3'd0: q = 16'h1232;  // Mapping for a=0
        3'd1: q = 16'haee0;  // Mapping for a=1
        3'd2: q = 16'h27d4;  // Mapping for a=2
        3'd3: q = 16'h5a0e;  // Mapping for a=3
        3'd4: q = 16'h2066;  // Mapping for a=4
        3'd5: q = 16'h64ce;  // Mapping for a=5
        3'd6: q = 16'hc526;  // Mapping for a=6
        3'd7: q = 16'h2f19;  // Mapping for a=7
    endcase
end

endmodule