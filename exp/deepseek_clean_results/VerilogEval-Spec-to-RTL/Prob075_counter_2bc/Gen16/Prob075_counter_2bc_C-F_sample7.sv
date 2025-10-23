module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;

// Optimized combinational logic with arithmetic saturation
assign next_state = areset ? 2'b01 :  // async reset has highest priority
                   train_valid ? 
                       (train_taken ? 
                           (state + (state != 2'b11)) :  // increment with saturation
                           (state - (state != 2'b00))) : // decrement with saturation
                       state;

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule