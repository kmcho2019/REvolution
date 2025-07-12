module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Async reset to weakly not-taken
    end
    else if (train_valid) begin
        if (train_taken) begin
            // Increment with saturation at 3
            state <= (state == 2'b11) ? 2'b11 : state + 1'b1;
        end
        else begin
            // Decrement with saturation at 0
            state <= (state == 2'b00) ? 2'b00 : state - 1'b1;
        end
    end
    // else hold state
end

endmodule