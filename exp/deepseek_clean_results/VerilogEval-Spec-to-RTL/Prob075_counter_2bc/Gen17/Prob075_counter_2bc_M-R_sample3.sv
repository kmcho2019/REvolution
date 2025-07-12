module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;

// Combinational next state logic using arithmetic with saturation
assign next_state = areset ? 2'b01 : 
                   (train_valid ? 
                       (train_taken ? 
                           (state == 2'b11 ? state : state + 1) :  // increment with saturation
                           (state == 2'b00 ? state : state - 1)    // decrement with saturation
                       ) : 
                       state);  // hold when not training

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end
    else begin
        state <= next_state;
    end
end

endmodule