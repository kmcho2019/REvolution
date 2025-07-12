module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON
    reg prev_j, prev_k;  // For input change detection

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF state
            prev_j <= 1'b0;
            prev_k <= 1'b0;
        end else if ((j != prev_j) || (k != prev_k)) begin
            // Only update state if inputs changed
            case (state)
                1'b0: state <= j ? 1'b1 : 1'b0;  // OFF: j=1 -> ON, else stay
                1'b1: state <= k ? 1'b0 : 1'b1;  // ON: k=1 -> OFF, else stay
            endcase
            prev_j <= j;
            prev_k <= k;
        end
    end

    assign out = state;  // Moore output depends only on state

endmodule