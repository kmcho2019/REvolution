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

    // Compact state transition logic with explicit case structure
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
            endcase
        end
    end

    // Direct state-to-output assignment for minimal logic
    assign out = state;

endmodule