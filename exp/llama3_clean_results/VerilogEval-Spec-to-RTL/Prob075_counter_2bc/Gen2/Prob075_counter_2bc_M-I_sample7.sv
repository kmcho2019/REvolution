module TopModule(
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to 2'b01
        state <= 2'b01;
    end else if (train_valid) begin
        // Determine the direction of update
        reg [1:0] new_state;
        if (train_taken) begin
            // Increment, saturate at 3
            new_state = (state == 2'b11) ? 2'b11 : state + 1'b1;
        end else begin
            // Decrement, saturate at 0
            new_state = (state == 2'b00) ? 2'b00 : state - 1'b1;
        end
        state <= new_state;
    end else begin
        // Keep the counter unchanged when not training
        state <= state;
    end
end

endmodule