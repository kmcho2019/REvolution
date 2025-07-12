module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] count_reg; // Internal register to hold the counter value
assign state = count_reg; // Continuous assignment to output the state

// Sequential logic to update the counter register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        count_reg <= 2'b01; // Asynchronous reset to the "weakly not-taken" state (2'b01)
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                count_reg <= (count_reg == 3) ? 3 : count_reg + 1; // Increment counter if train_taken is high
            end else begin
                count_reg <= (count_reg == 0) ? 0 : count_reg - 1; // Decrement counter if train_taken is low
            end
        end else begin
            // Do nothing if train_valid is low
        end
    end
end

endmodule