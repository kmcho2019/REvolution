module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;

// Combinational next-state logic
assign next_state = 
    ~train_valid ? state :  // Hold state when not training
    train_taken ? 
        (state == 2'b11 ? 2'b11 : state + 1'b1) :  // Increment (saturate at 3)
        (state == 2'b00 ? 2'b00 : state - 1'b1);   // Decrement (saturate at 0)

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to weakly not-taken
    end else begin
        state <= next_state;
    end
end

endmodule