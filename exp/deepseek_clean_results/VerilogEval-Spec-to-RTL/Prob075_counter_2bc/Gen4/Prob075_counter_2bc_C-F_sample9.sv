module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;

// Optimized combinational logic with arithmetic and saturation
assign next_state = train_valid ? 
                   (train_taken ? (state + (state != 2'b11)) : 
                                  (state - (state != 2'b00))) : 
                   state;

// Efficient sequential logic with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;  // Reset to weakly not-taken
    else
        state <= next_state;
end

endmodule