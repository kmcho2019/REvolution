module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF state
        end else begin
            case (state)
                1'b0: state <= j ? 1'b1 : 1'b0;  // OFF: j=1 -> ON, else stay
                1'b1: state <= k ? 1'b0 : 1'b1;  // ON: k=1 -> OFF, else stay
            endcase
        end
    end

    assign out = state;  // Moore output depends only on state

endmodule