module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;          // 0 = OFF, 1 = ON
    reg j_prev, k_prev; // Previous input values

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;      // Reset to OFF state
            j_prev <= 1'b0;
            k_prev <= 1'b0;
        end else if (j != j_prev || k != k_prev) begin
            // Only update state if inputs changed
            case (state)
                1'b0: state <= j ? 1'b1 : 1'b0;  // OFF: j=1 -> ON, else stay
                1'b1: state <= k ? 1'b0 : 1'b1;  // ON: k=1 -> OFF, else stay
            endcase
            j_prev <= j;
            k_prev <= k;
        end
    end

    assign out = state;  // Moore output depends only on state

endmodule