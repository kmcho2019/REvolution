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
            if (train_taken && (counter != 2'b11)) begin
                counter <= counter + 1;  // Increment if not saturated
            end else if (!train_taken && (counter != 2'b00)) begin
                counter <= counter - 1;  // Decrement if not saturated
            end
            // Else counter remains unchanged (implied)
        end
        // Else counter remains unchanged (implied)
    end

    assign state = counter;

endmodule