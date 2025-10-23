module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state 1 (weakly not-taken)
    end else if (train_valid) begin
        reg [1:0] next_state;
        if (train_taken) begin
            next_state = (state == 2'b11) ? 2'b11 : state + 2'b01;
        end else begin
            next_state = (state == 2'b00) ? 2'b00 : state - 2'b01;
        end
        state <= next_state;
    end else begin
        // When train_valid is low, stay in the current state
        state <= state;
    end
end

endmodule