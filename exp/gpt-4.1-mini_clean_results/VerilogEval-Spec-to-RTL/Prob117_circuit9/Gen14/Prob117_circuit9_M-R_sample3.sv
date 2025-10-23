module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] state;

wire [2:0] next_state = (a) ? 3'd4 : ((state == 3'd6) ? 3'd0 : state + 3'd1);

always @(posedge clk) begin
    state <= next_state;
    q <= next_state;
end

endmodule