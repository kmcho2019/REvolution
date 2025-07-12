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
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                if (state < 2'b11) begin // increment up to 3
                    state <= state + 1'b1;
                end
            end else begin
                if (state > 2'b00) begin // decrement down to 0
                    state <= state - 1'b1;
                end
            end
        end
    end
end

endmodule