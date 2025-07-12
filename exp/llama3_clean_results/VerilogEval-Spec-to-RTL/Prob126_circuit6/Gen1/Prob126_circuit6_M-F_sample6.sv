module TopModule(
    input  [2:0] a,
    output [15:0] q
);
reg [15:0] q_reg; // Declare 'q' as a reg for procedural assignment

always @(*) begin
    case(a)
        3'd0: q_reg = 16'h1232;
        3'd1: q_reg = 16'haee0;
        3'd2: q_reg = 16'h27d4;
        3'd3: q_reg = 16'h5a0e;
        3'd4: q_reg = 16'h2066;
        3'd5: q_reg = 16'h64ce;
        3'd6: q_reg = 16'hc526;
        3'd7: q_reg = 16'h2f19;
        default: q_reg = 16'hxxxx; // default value
    endcase
end

assign q = q_reg; // Assign the value of 'q_reg' to output 'q'

endmodule