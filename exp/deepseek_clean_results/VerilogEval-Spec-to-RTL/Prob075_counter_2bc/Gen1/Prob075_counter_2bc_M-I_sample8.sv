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
            // Simplified increment/decrement with natural saturation
            if (train_taken) begin
                counter <= counter + (counter != 2'b11);  // Increment if not max
            end else begin
                counter <= counter - (counter != 2'b00);  // Decrement if not min
            end
        end
        // Else: counter remains unchanged
    end

    assign state = counter;

endmodule