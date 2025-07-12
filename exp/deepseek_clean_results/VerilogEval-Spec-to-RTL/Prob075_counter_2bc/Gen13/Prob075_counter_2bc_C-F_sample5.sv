module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;
wire do_increment = train_valid & train_taken;
wire do_decrement = train_valid & ~train_taken;

// Single arithmetic operation with direction control
wire [2:0] temp_next = {1'b0, state} + (do_increment ? 3'b001 : (do_decrement ? 3'b111 : 3'b000));

// Efficient saturation using overflow/underflow detection
assign next_state = areset ? 2'b01 :  // Async reset to weakly-not-taken
                   (temp_next[2] ? (do_increment ? 2'b11 : 2'b00) : temp_next[1:0]);

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule