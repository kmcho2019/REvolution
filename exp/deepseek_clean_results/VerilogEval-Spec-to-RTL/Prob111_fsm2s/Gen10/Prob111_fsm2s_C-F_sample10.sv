module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // Clear state encoding with optimal binary representation
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    // Optimized state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= j ? ON : OFF;  // Only transition when j=1
                ON:  state <= k ? OFF : ON;  // Only transition when k=1
            endcase
        end
    end

    // Direct state-to-output assignment
    assign out = state;

endmodule