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
            // Increment if taken (saturate at 3), decrement if not taken (saturate at 0)
            counter <= train_taken ? (counter == 2'b11 ? 2'b11 : counter + 1)
                                  : (counter == 2'b00 ? 2'b00 : counter - 1);
        end
    end

    assign state = counter;

endmodule