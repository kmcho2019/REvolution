module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;  // Reset to weakly not-taken
        end else if (train_valid) begin
            if (train_taken && counter != 2'b11) begin
                counter <= counter + 1;  // Increment if not at max
            end else if (!train_taken && counter != 2'b00) begin
                counter <= counter - 1;  // Decrement if not at min
            end
            // Else: counter stays at current value (saturated)
        end
        // Else: counter remains unchanged
    end

    assign state = counter;

endmodule