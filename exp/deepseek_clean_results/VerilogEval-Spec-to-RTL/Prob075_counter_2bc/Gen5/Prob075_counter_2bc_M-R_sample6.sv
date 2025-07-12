module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Weakly not-taken state on reset
    end
    else begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment with saturation at 3
                if (state != 2'b11) state <= state + 1;
            end
            else begin
                // Decrement with saturation at 0
                if (state != 2'b00) state <= state - 1;
            end
        end
        // If not training, state remains unchanged (implicit)
    end
end

endmodule