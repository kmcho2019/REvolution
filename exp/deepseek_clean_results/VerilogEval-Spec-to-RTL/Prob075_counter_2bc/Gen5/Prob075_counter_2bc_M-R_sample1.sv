module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter;

    // Next state logic using continuous assignment
    wire [1:0] next_counter;
    assign next_counter = areset ? 2'b01 :               // Reset condition
                         train_valid ? 
                             (train_taken ? 
                                 (counter == 2'b11 ? 2'b11 : counter + 1) :  // Increment with saturation
                                 (counter == 2'b00 ? 2'b00 : counter - 1)    // Decrement with saturation
                             ) : counter;                // Hold when not training

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;  // Reset to weakly not-taken
        end else begin
            counter <= next_counter;
        end
    end

    assign state = counter;

endmodule