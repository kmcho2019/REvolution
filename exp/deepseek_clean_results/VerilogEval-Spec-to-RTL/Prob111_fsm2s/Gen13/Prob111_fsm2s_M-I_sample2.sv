module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding remains optimal
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    wire state_en;

    // Clock gating condition - only enable transitions when needed
    assign state_en = reset || 
                     (state == OFF && j) || 
                     (state == ON && k);

    // Optimized state transition logic using AND/OR instead of ternary
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else if (state_en) begin
            (* parallel_case *)
            case (state)
                OFF: state <= ON;  // Only reach here when j=1
                ON:  state <= OFF; // Only reach here when k=1
            endcase
        end
    end

    // Direct state-to-output assignment remains optimal
    assign out = state;

endmodule