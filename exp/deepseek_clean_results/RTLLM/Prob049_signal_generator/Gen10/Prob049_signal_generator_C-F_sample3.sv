module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end else begin
        // Optimized boundary detection and state transition
        if (state) begin
            wave <= wave - (|wave);  // Decrement if not zero
            state <= (|wave) ? state : ~state;  // Toggle state at zero
        end else begin
            wave <= wave + (&(~wave));  // Increment if not all ones
            state <= (&wave) ? ~state : state;  // Toggle state at max
        end
    end
end

endmodule