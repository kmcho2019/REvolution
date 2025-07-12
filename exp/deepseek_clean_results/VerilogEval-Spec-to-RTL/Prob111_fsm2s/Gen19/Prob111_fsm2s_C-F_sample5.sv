module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State definitions for better readability
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state;  // Current state (OFF or ON)

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;  // Synchronous reset to OFF
        end else begin
            // Optimized state transition logic
            state <= (state & ~k) | (~state & j);
        end
    end

    // Output assignment (Moore machine)
    assign out = state;

endmodule