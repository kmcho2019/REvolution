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
            if (train_taken) begin
                // Increment, saturating at 3 (check using bitwise AND)
                counter <= (&counter) ? 2'b11 : counter + 1;
            end else begin
                // Decrement, saturating at 0 (check using reduction NOR)
                counter <= (|counter) ? counter - 1 : 2'b00;
            end
        end
        // Else: counter remains unchanged (implicit)
    end

    assign state = counter;

endmodule