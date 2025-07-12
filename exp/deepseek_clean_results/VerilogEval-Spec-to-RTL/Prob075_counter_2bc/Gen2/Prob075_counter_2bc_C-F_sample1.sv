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
            // Parallel evaluation of increment/decrement with optimized saturation
            counter <= train_taken ? 
                      ((&counter) ? 2'b11 : counter + 1) :  // Increment with saturation
                      ((|counter) ? counter - 1 : 2'b00);    // Decrement with saturation
        end
    end

    assign state = counter;

endmodule