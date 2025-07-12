module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

// One-hot state encoding (10 states for 1-10)
reg [9:0] state;

// Next state logic
wire [9:0] next_state = reset ? 10'b0000000001 :  // Reset to state 1
                       (state == 10'b1000000000) ? 10'b0000000001 :  // Wrap from 10 to 1
                       {state[8:0], 1'b0};  // Normal shift-left operation

// State register
always @(posedge clk) begin
    state <= next_state;
end

// Output encoding (one-hot to binary)
assign q[3] = state[9] | state[8] | state[7] | state[6];  // 8,9,10 or 7
assign q[2] = state[9] | state[8] | state[5] | state[4];  // 8,9,10 or 5,6
assign q[1] = state[9] | state[7] | state[5] | state[3] | state[1];  // 10,8,6,4,2
assign q[0] = state[8] | state[6] | state[4] | state[2] | state[0];  // 9,7,5,3,1

endmodule