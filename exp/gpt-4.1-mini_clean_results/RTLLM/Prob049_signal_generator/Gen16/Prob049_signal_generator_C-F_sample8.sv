module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state;  // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;       // start incrementing
        end else begin
            // Update wave based on state (direction)
            if (state == 1'b0) begin
                wave <= wave + 5'd1;
                // If wave reached max, toggle direction
                if (wave == 5'd31)
                    state <= 1'b1;
            end else begin
                wave <= wave - 5'd1;
                // If wave reached min, toggle direction
                if (wave == 5'd0)
                    state <= 1'b0;
            end
        end
    end

endmodule