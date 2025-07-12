module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0; // OFF state
        end else begin
            if (state == 1'b0) begin
                // From OFF, j controls transition
                if (j)
                    state <= 1'b1;
                else
                    state <= 1'b0;
            end else begin
                // From ON, k controls transition
                if (k)
                    state <= 1'b0;
                else
                    state <= 1'b1;
            end
        end
    end

    // Moore output depends only on state
    assign out = state;

endmodule