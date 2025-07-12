module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [15:0] state;
wire [15:0] next_state;

// Next state logic - circular shift
assign next_state = reset ? 16'h0001 : 
                   {state[14:0], state[15]};

// State register
always @(posedge clk) begin
    state <= next_state;
end

// Output encoding - convert one-hot to binary
assign q = (state[0]  ? 4'd0  :
           state[1]  ? 4'd1  :
           state[2]  ? 4'd2  :
           state[3]  ? 4'd3  :
           state[4]  ? 4'd4  :
           state[5]  ? 4'd5  :
           state[6]  ? 4'd6  :
           state[7]  ? 4'd7  :
           state[8]  ? 4'd8  :
           state[9]  ? 4'd9  :
           state[10] ? 4'd10 :
           state[11] ? 4'd11 :
           state[12] ? 4'd12 :
           state[13] ? 4'd13 :
           state[14] ? 4'd14 :
                       4'd15);

endmodule