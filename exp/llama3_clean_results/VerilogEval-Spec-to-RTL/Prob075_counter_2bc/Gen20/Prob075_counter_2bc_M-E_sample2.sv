module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] counter; // Internal register to hold the counter value
assign state = counter; // Continuous assignment to output the state

// Sequential logic to update the counter register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 2'b01; // Asynchronous reset to the value 1 (LOW state)
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment the counter, saturating at 3
                counter <= (counter == 2'b11) ? 2'b11 : counter + 1'b1;
            end else begin
                // Decrement the counter, saturating at 0
                counter <= (counter == 2'b00) ? 2'b00 : counter - 1'b1;
            end
        end else begin
            // Keep the counter value unchanged when not training
            counter <= counter;
        end
    end
end

endmodule