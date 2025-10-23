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
            // Combined increment/decrement with saturation
            if (train_taken && counter != 2'b11)
                counter <= counter + 1;
            else if (!train_taken && counter != 2'b00)
                counter <= counter - 1;
        end
        // Else: counter remains unchanged (implicit)
    end

    assign state = counter;

endmodule