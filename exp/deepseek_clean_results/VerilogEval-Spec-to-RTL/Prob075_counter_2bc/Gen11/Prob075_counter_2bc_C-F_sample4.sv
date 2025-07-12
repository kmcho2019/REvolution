module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    // State definitions and parameters
    localparam RESET_VALUE = 2'b01;  // Weakly not-taken
    reg [1:0] counter;

    // Next state logic
    wire [1:0] next_counter;
    assign next_counter = (train_valid & train_taken) ? 
                            (counter == 2'b11 ? 2'b11 : counter + 1) :  // Increment with saturation
                         (train_valid & ~train_taken) ? 
                            (counter == 2'b00 ? 2'b00 : counter - 1) :  // Decrement with saturation
                         counter;  // Hold when not training

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= RESET_VALUE;
        end else begin
            counter <= next_counter;
        end
    end

    assign state = counter;

endmodule