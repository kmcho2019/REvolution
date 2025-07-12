module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to weakly not-taken
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                if (state < 3) begin // Check for saturation
                    state <= state + 1;
                end else begin
                    state <= state; // Saturate at 3
                end
            end else begin
                if (state > 0) begin // Check for saturation
                    state <= state - 1;
                end else begin
                    state <= state; // Saturate at 0
                end
            end
        end else begin
            state <= state; // Do not change when not training
        end
    end
end

endmodule