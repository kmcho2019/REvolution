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
        end else begin
            if (train_valid) begin
                if (train_taken) begin
                    // Increment, but saturate at 3
                    counter <= (counter == 2'b11) ? 2'b11 : counter + 1;
                end else begin
                    // Decrement, but saturate at 0
                    counter <= (counter == 2'b00) ? 2'b00 : counter - 1;
                end
            end
            // If train_valid is 0, counter remains unchanged (implicit)
        end
    end

    assign state = counter;

endmodule