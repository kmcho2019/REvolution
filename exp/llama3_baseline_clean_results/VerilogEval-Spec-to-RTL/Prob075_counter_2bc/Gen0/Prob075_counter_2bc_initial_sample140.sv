module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to weakly not-taken state
    end else if (train_valid) begin
        if (train_taken) begin
            if (state == 2'b11) begin // Saturate at maximum value
                state <= 2'b11;
            end else begin
                state <= state + 1'b1;
            end
        end else begin
            if (state == 2'b00) begin // Saturate at minimum value
                state <= 2'b00;
            end else begin
                state <= state - 1'b1;
            end
        end
    end
end

endmodule