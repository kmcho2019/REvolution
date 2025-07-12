module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            state <= 1'b0;
        end else begin
            // State transition decisions at boundary
            if (state == 1'b0) begin  // increment mode
                if (wave == 5'd31) begin
                    state <= 1'b1;  // switch to decrement
                    // no wave update to avoid redundant toggling
                end else begin
                    wave <= wave + 5'd1;
                end
            end else begin  // decrement mode
                if (wave == 5'd0) begin
                    state <= 1'b0;  // switch to increment
                    // no wave update to avoid redundant toggling
                end else begin
                    wave <= wave - 5'd1;
                end
            end
        end
    end

endmodule