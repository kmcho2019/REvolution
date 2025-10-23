module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset state to 2'b01
    end else if (train_valid) begin
        if (train_taken && state < 2'd3) begin  // Increment if not at maximum
            state <= state + 1;
        end else if (!train_taken && state > 2'd0) begin  // Decrement if not at minimum
            state <= state - 1;
        end
    end
end

endmodule