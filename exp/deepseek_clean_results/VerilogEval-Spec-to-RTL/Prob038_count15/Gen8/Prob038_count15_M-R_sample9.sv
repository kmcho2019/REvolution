module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] state;
wire [3:0] next_state;

// Next state computation using continuous assignments
assign next_state[0] = ~state[0];
assign next_state[1] = state[0] ? ~state[1] : state[1];
assign next_state[2] = (state[1] & state[0]) ? ~state[2] : state[2];
assign next_state[3] = (state[2] & state[1] & state[0]) ? ~state[3] : state[3];

// Sequential state update
always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0000;
    end
    else begin
        state <= next_state;
    end
end

assign q = state;

endmodule