module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State encoding with localparam for clarity
    reg state;
    reg prev_j, prev_k;  // For input change detection
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // State transition with input change detection
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            prev_j <= 0;
            prev_k <= 0;
        end else if (j != prev_j || k != prev_k) begin
            prev_j <= j;
            prev_k <= k;
            // Simplified state transition logic
            state <= (state == OFF) ? j : ~k;
        end
    end

    // Moore output depends only on state
    assign out = state;

endmodule