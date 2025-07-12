module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to '01'
        state <= 2'b01;
    end else begin
        if (train_valid) begin
            // If training is valid
            if (train_taken) begin
                // If train is taken, increment counter but saturate at 3
                state <= (state == 2'b11) ? 2'b11 : state + 1'b1;
            end else begin
                // If train is not taken, decrement counter but saturate at 0
                state <= (state == 2'b00) ? 2'b00 : state - 1'b1;
            end
        end else begin
            // If training is not valid, hold the current state
            state <= state;
        end
    end
end

endmodule