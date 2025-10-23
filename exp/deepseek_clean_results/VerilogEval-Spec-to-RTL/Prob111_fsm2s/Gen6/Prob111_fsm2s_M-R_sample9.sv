module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state; // 0 = OFF, 1 = ON

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;
        else
            state <= (state == 1'b0) ? j : ~k;
    end

    // Output logic (Moore style)
    assign out = state;

endmodule