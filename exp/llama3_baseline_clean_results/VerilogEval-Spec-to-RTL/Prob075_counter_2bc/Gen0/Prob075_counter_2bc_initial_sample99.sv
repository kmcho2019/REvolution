module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 2'b01; // reset to weakly not-taken
    end else if (train_valid) begin
        if (train_taken) begin
            if (state < 2'b11) begin // check for saturation
                state <= state + 1;
            end
        end else begin
            if (state > 2'b00) begin // check for saturation
                state <= state - 1;
            end
        end
    end
end

endmodule