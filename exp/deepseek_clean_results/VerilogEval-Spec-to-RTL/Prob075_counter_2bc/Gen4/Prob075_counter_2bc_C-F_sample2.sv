module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    // Combinational next state logic
    wire [1:0] next_state;
    assign next_state = (train_valid) ? 
        (train_taken ? 
            (state == 2'b11 ? 2'b11 : state + 1) :  // Increment with saturation
            (state == 2'b00 ? 2'b00 : state - 1)    // Decrement with saturation
        ) : state;                                  // Hold when not training

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // Reset to weakly not-taken
        else
            state <= next_state;
    end

endmodule