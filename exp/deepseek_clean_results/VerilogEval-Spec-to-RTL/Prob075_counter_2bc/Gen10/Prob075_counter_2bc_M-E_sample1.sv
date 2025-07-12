module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter;
    wire max_saturated = &counter;    // All bits set (3)
    wire min_saturated = ~|counter;   // All bits clear (0)

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;  // Weakly not-taken state
        end else if (train_valid) begin
            if (train_taken) begin
                // Increment with saturation
                if (!max_saturated) counter <= {counter[0], 1'b1};
            end else begin
                // Decrement with saturation
                if (!min_saturated) counter <= {1'b0, counter[1]};
            end
        end
    end

    assign state = counter;

endmodule