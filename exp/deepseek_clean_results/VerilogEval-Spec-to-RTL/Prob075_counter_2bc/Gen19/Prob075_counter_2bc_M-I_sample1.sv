module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;
wire [1:0] inc_state = state + 1'b1;
wire [1:0] dec_state = state - 1'b1;

// Optimized combinational logic
assign next_state = areset ? 2'b01 :          // Async reset
                   (train_valid & train_taken) ? (state == 2'b11 ? state : inc_state) :
                   (train_valid & ~train_taken) ? (state == 2'b00 ? state : dec_state) :
                   state;

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule