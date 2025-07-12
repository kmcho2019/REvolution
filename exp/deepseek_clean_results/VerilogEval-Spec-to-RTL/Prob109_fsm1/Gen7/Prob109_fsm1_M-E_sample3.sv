module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Shift register implementation
    reg [1:0] state_shift;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_shift <= 2'b11;  // Initialize to state B (1)
        end else begin
            // Shift in new state based on current oldest bit and input
            state_shift <= {state_shift[0], 
                          (state_shift[1] ? (in ? 1'b1 : 1'b0) : 
                                           (in ? 1'b0 : 1'b1))};
        end
    end
    
    // Output is the oldest bit in the shift register
    assign out = state_shift[1];
    
endmodule