module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire do_increment = train_valid & train_taken;
wire do_decrement = train_valid & ~train_taken;

wire [1:0] next_state_inc = (state == 2'b11) ? state : state + 1;
wire [1:0] next_state_dec = (state == 2'b00) ? state : state - 1;

wire [1:0] next_state = 
    do_increment ? next_state_inc :
    do_decrement ? next_state_dec :
    state;

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule