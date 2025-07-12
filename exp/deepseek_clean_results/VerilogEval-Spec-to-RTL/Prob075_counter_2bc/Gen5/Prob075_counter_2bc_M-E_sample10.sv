module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;

// Increment/decrement logic with saturation
assign next_state = 
    (train_valid & train_taken) ? (state + 1'b1) & 2'b11 :  // Increment with max 3
    (train_valid & ~train_taken) ? (state - 1'b1) | {2{state == 2'b00}} :  // Decrement with min 0
    state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end else begin
        state <= next_state;
    end
end

endmodule