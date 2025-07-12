module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // 2-bit shift register implementation
    reg [1:0] state_history;
    
    always @(posedge clk) begin
        if (reset) begin
            state_history <= 2'b10; // Initialize to state B (LSB=0)
        end else begin
            // Shift in new state based on current state (LSB) and input
            state_history <= {state_history[0], 
                            state_history[0] ? in : ~in};
        end
    end

    // Output is complement of LSB (B=0->out=1, A=1->out=0)
    assign out = ~state_history[0];

endmodule