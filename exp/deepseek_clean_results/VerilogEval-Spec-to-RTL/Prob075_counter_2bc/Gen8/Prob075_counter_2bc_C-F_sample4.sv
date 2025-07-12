module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

localparam RESET_VALUE = 2'b01;
wire [1:0] next_state;

// Optimized next state calculation with arithmetic saturation
assign next_state = areset ? RESET_VALUE : 
                   (train_valid ? 
                       (train_taken ? 
                           (state + (state != 2'b11)) :  // Increment with saturation
                           (state - (state != 2'b00))) : // Decrement with saturation
                       state);

// Sequential logic with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= RESET_VALUE;
    else
        state <= next_state;
end

endmodule