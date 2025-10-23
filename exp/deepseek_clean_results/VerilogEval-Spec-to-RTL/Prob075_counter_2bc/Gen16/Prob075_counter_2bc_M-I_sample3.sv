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
wire clk_enable = train_valid | areset;

// Next state calculation with optimized saturation logic
assign next_state = (do_increment & (state != 2'b11)) ? state + 1 :
                   (do_decrement & (state != 2'b00)) ? state - 1 :
                   state;

// Clock-gated state register with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else if (clk_enable)
        state <= next_state;
end

endmodule