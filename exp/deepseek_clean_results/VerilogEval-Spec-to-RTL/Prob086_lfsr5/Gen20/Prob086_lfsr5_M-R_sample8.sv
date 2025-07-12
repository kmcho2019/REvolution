module TopModule (
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state = 1;
wire feedback;
wire [4:0] next_state;

assign feedback = state[0];
assign next_state = reset ? 5'b00001 : 
                   {feedback,
                    state[4],
                    state[3] ^ feedback,
                    state[2],
                    state[1]};

always @(posedge clk)
    state <= next_state;

assign q = state;

endmodule