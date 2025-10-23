module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to weakly not-taken (2'b01)
    end else if (train_valid) begin
        if (train_taken) begin
            if (state == 2'b11) begin // Maximum value, saturate
                state <= 2'b11;
            end else begin
                state <= state + 1'b1; // Increment
            end
        end else begin
            if (state == 2'b00) begin // Minimum value, saturate
                state <= 2'b00;
            end else begin
                state <= state - 1'b1; // Decrement
            end
        end
    end // else, when train_valid is 0, state remains unchanged
end

endmodule