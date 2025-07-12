module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State encoding with localparam for clarity
    reg state;
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // Input change detection registers
    reg prev_j, prev_k;

    // Combined state transition and register logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            prev_j <= 1'b0;
            prev_k <= 1'b0;
        end else begin
            // Only update state if inputs changed
            if (j != prev_j || k != prev_k) begin
                if (state == OFF) begin
                    state <= j ? ON : OFF;
                end else begin
                    state <= k ? OFF : ON;
                end
            end
            prev_j <= j;
            prev_k <= k;
        end
    end

    // Moore output depends only on state
    assign out = state;

endmodule