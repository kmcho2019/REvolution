module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] counter;

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01; // weakly not-taken
        end else if (train_valid) begin
            if (train_taken) begin
                // Increment saturating at 3
                if (counter != 2'b11)
                    counter <= counter + 1;
                else
                    counter <= counter; // saturate at max
            end else begin
                // Decrement saturating at 0
                if (counter != 2'b00)
                    counter <= counter - 1;
                else
                    counter <= counter; // saturate at min
            end
        end else begin
            counter <= counter; // hold state if no training
        end
    end

    // Output state is the counter value
    always @(*) begin
        state = counter;
    end

endmodule