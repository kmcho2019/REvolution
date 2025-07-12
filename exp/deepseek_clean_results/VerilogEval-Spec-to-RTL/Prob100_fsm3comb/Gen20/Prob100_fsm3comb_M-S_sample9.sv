module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(*) begin
    out = (state == 2'b11);  // Output is high only in state D
    
    // State transition logic using parallel ternary expressions
    next_state[0] = (state == 2'b00) ? in :  // A
                   (state == 2'b01) ? in :  // B
                   (state == 2'b10) ? 1'b1 : // C
                   ~in;                      // D
    
    next_state[1] = (state == 2'b00) ? 1'b0 :  // A
                   (state == 2'b01) ? ~in :    // B
                   (state == 2'b10) ? in :     // C
                   in;                         // D
end

endmodule