module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter;

    // Next state logic with simplified arithmetic and saturation
    wire [1:0] next_counter;
    assign next_counter = train_valid ? 
                         (train_taken ? 
                             {~(&counter), counter[0] | counter[1]} :  // Increment with saturation
                             {counter[1] & counter[0], ~(|counter)}    // Decrement with saturation
                         ) : counter;

    // Sequential logic with clock gating
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;  // Reset to weakly not-taken
        end else if (train_valid) begin
            counter <= next_counter;
        end
    end

    assign state = counter;

endmodule