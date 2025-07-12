module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON
    reg next_state;

    always @(*) begin
        if (state == 1'b0) begin
            // From OFF, j controls transition
            if (j)
                next_state = 1'b1;
            else
                next_state = 1'b0;
        end else begin
            // From ON, k controls transition
            if (k)
                next_state = 1'b0;
            else
                next_state = 1'b1;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0; // OFF state
        end else if (state != next_state) begin
            state <= next_state; // Update only if changed
        end
    end

    // Moore output depends only on state
    assign out = state;

endmodule