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
            state_shift <= 2'b10; // Initialize to state B
        end else begin
            // Shift with conditional inversion based on input
            state_shift <= {state_shift[0] ^ (state_shift[1] & ~in), 
                           state_shift[1] ^ (state_shift[0] & in)};
        end
    end
    
    // Output is MSB of shift register
    assign out = state_shift[1];
    
endmodule