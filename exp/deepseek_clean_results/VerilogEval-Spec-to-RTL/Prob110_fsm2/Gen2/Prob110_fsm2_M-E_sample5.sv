module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State encoding with Gray code (single bit)
    reg state;
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // Input change detection registers
    reg prev_j, prev_k;
    wire inputs_changed = (prev_j != j) || (prev_k != k);

    // Combined transition control signal
    wire transition_cond = j ^ k;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            prev_j <= 1'b0;
            prev_k <= 1'b0;
        end else if (inputs_changed) begin
            prev_j <= j;
            prev_k <= k;
            // Simplified transition logic
            if (transition_cond) begin
                state <= (state == OFF) ? j : ~k;
            end
            // Else maintain state (when j==k)
        end
    end

    // Output assignment (combinational)
    assign out = state;

    /* Optional registered output version
    reg out_reg;
    always @(posedge clk or posedge areset) begin
        if (areset) out_reg <= 1'b0;
        else out_reg <= state;
    end
    assign out = out_reg;
    */
endmodule