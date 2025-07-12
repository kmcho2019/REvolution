module TopModule (
    output out
);
    // Random input bits for LUT (unused in final output)
    wire [1:0] random_inputs = {$random} & 2'b11;
    
    // 2-bit LUT programmed to always output 0
    assign out = (random_inputs == 2'b00) ? 1'b0 :
                 (random_inputs == 2'b01) ? 1'b0 :
                 (random_inputs == 2'b10) ? 1'b0 :
                 1'b0;
endmodule