module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // reset to weakly not-taken
    end else if (train_valid) begin
        if (train_taken) begin
            if (state < 2'b11) begin // check for maximum value
                state <= state + 1'b1;
            end
        end else begin
            if (state > 2'b00) begin // check for minimum value
                state <= state - 1'b1;
            end
        end
    end
end

endmodule