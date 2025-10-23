module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;

// Calculate next state with saturation
assign next_state = train_valid ? 
                   (train_taken ? 
                       (state == 2'b11 ? 2'b11 : state + 1'b1) :  // saturate at max
                       (state == 2'b00 ? 2'b00 : state - 1'b1)) :  // saturate at min
                   state;  // hold when not training

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Weakly not-taken state
    end else begin
        state <= next_state;
    end
end

endmodule