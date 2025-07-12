module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;
wire signed [1:0] state_change = train_valid ? (train_taken ? 1 : -1) : 0;
wire signed [2:0] next_state_temp = state + state_change;

assign next_state = (next_state_temp > 3) ? 2'b11 :
                    (next_state_temp < 0) ? 2'b00 :
                    next_state_temp[1:0];

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01;
    else
        state <= next_state;
end

endmodule