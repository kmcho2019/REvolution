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
                if (state < 3) begin
                    state <= state + 1; // increment up to 3
                end
            end else begin
                if (state > 0) begin
                    state <= state - 1; // decrement down to 0
                end
            end
        end
    end
end

endmodule