module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

// Next state calculation using arithmetic operations
wire [1:0] next_state;

assign next_state = areset ? 2'b01 :  // Weakly not-taken on reset
                   train_valid ? 
                   (train_taken ? 
                    (state == 2'b11 ? 2'b11 : state + 1'b1) :  // Increment with saturation
                    (state == 2'b00 ? 2'b00 : state - 1'b1)) : // Decrement with saturation
                   state;  // Hold current state when not training

// State register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule