module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out_sop,
    output reg out_pos
);

always @(*) begin
    case ({a,b,c,d})
        4'b0000: begin out_sop = 0; out_pos = 0; end  // 0
        4'b0001: begin out_sop = 0; out_pos = 0; end  // 1
        4'b0010: begin out_sop = 1; out_pos = 1; end  // 2
        4'b0011: begin out_sop = 0; out_pos = 0; end  // 3 (don't care)
        4'b0100: begin out_sop = 0; out_pos = 0; end  // 4
        4'b0101: begin out_sop = 0; out_pos = 0; end  // 5
        4'b0110: begin out_sop = 0; out_pos = 0; end  // 6
        4'b0111: begin out_sop = 1; out_pos = 1; end  // 7
        4'b1000: begin out_sop = 0; out_pos = 0; end  // 8 (don't care)
        4'b1001: begin out_sop = 0; out_pos = 0; end  // 9
        4'b1010: begin out_sop = 0; out_pos = 0; end  // 10
        4'b1011: begin out_sop = 0; out_pos = 0; end  // 11 (don't care)
        4'b1100: begin out_sop = 0; out_pos = 0; end  // 12 (don't care)
        4'b1101: begin out_sop = 0; out_pos = 0; end  // 13
        4'b1110: begin out_sop = 0; out_pos = 0; end  // 14
        4'b1111: begin out_sop = 1; out_pos = 1; end  // 15
        default: begin out_sop = 0; out_pos = 0; end
    endcase
end

endmodule