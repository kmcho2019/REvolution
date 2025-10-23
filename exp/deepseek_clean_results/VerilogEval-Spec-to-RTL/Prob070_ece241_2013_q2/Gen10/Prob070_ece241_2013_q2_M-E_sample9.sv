module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out_sop,
    output reg out_pos
);

    always @(*) begin
        // Combine inputs into a 4-bit value
        case ({a,b,c,d})
            4'b0010: begin out_sop = 1'b1; out_pos = 1'b1; end  // 2
            4'b0111: begin out_sop = 1'b1; out_pos = 1'b1; end  // 7
            4'b1111: begin out_sop = 1'b1; out_pos = 1'b1; end  // 15
            
            4'b0000: begin out_sop = 1'b0; out_pos = 1'b0; end  // 0
            4'b0001: begin out_sop = 1'b0; out_pos = 1'b0; end  // 1
            4'b0100: begin out_sop = 1'b0; out_pos = 1'b0; end  // 4
            4'b0101: begin out_sop = 1'b0; out_pos = 1'b0; end  // 5
            4'b0110: begin out_sop = 1'b0; out_pos = 1'b0; end  // 6
            4'b1001: begin out_sop = 1'b0; out_pos = 1'b0; end  // 9
            4'b1010: begin out_sop = 1'b0; out_pos = 1'b0; end  // 10
            4'b1101: begin out_sop = 1'b0; out_pos = 1'b0; end  // 13
            4'b1110: begin out_sop = 1'b0; out_pos = 1'b0; end  // 14
            
            // Don't-care cases (3,8,11,12) - outputs can be anything
            default: begin out_sop = 1'b0; out_pos = 1'b1; end
        endcase
    end

endmodule