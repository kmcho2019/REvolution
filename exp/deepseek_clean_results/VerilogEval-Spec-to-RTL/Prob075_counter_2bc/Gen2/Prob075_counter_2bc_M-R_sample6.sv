module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;

// Next state calculation
assign next_state = 
    (train_valid & train_taken) ? ((state == 2'b11) ? 2'b11 : state + 1) :
    (train_valid & ~train_taken) ? ((state == 2'b00) ? 2'b00 : state - 1) :
    state;

// State register with async reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule