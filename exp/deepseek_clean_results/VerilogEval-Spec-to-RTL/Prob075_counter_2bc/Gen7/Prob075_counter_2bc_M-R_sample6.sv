module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter;

    // Next counter value calculation
    wire [1:0] next_counter;
    assign next_counter = train_taken ? 
                         (counter == 2'b11 ? 2'b11 : counter + 1'b1) :  // saturating increment
                         (counter == 2'b00 ? 2'b00 : counter - 1'b1);   // saturating decrement

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;  // Reset to weakly not-taken
        end else if (train_valid) begin
            counter <= next_counter;
        end
        // Else: counter remains unchanged
    end

    assign state = counter;

endmodule