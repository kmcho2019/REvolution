module TopModule (
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // reset to weakly not-taken state
    end else if (train_valid) begin
        if (train_taken) begin
            state <= (state == 2'b11) ? state : state + 1; // increment, saturate at 3
        end else begin
            state <= (state == 2'b00) ? state : state - 1; // decrement, saturate at 0
        end
    end
end

endmodule