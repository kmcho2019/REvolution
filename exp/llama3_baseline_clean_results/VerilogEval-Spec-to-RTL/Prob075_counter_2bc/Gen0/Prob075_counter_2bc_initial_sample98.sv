module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to weakly not-taken state
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                if (state < 2'b11) begin // Saturating increment
                    state <= state + 1;
                end
            end else begin
                if (state > 2'b00) begin // Saturating decrement
                    state <= state - 1;
                end
            end
        end // else, state remains unchanged when train_valid is 0
    end
end

endmodule