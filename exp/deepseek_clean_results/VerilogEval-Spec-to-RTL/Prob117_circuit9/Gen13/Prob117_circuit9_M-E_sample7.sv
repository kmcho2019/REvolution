module TopModule (
    input clk,
    input a,
    output [2:0] q
);

// One-hot encoded state register (states 0-6)
reg [6:0] state;

// Next state logic
wire [6:0] next_state = a ? 7'b0001000 :  // State 4 when a=1
                       state[6] ? 7'b0000001 : // Wrap from 6 to 0
                       {state[5:0], 1'b0}; // Left shift for increment

// State update
always @(posedge clk) begin
    state <= next_state;
end

// Output encoding
assign q = state[0] ? 3'd0 :
           state[1] ? 3'd1 :
           state[2] ? 3'd2 :
           state[3] ? 3'd3 :
           state[4] ? 3'd4 :
           state[5] ? 3'd5 :
           3'd6; // state[6]

endmodule