module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state_shift;

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b11; // Reset to state B (output 1)
        end else begin
            // Shift in new state based on input and current state
            state_shift <= {state_shift[0], 
                          (state_shift[0] ? (in ? 1'b1 : 1'b0)  // If in B
                                           : (in ? 1'b0 : 1'b1))}; // If in A
        end
    end

    // Output is the complement of current state (B=1, A=0)
    assign out = state_shift[0];

endmodule