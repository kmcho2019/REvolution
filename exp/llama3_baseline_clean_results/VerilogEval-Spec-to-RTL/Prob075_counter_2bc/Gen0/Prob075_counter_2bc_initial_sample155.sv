module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to weakly not-taken
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                if (state < 2'b11) begin
                    state <= state + 1'b1; // Increment if not at maximum
                end else begin
                    state <= state; // Saturate at maximum
                end
            end else begin
                if (state > 2'b00) begin
                    state <= state - 1'b1; // Decrement if not at minimum
                end else begin
                    state <= state; // Saturate at minimum
                end
            end
        end else begin
            state <= state; // Hold the value if not training
        end
    end
end

endmodule