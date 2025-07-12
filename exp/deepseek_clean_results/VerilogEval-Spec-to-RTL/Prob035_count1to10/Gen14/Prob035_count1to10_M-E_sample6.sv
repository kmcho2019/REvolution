module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [9:0] state;  // One-hot states for 1-10
wire [3:0] q_out;

// Priority encoder for state to binary output
assign q_out = (state[0]) ? 4'b0001 :
               (state[1]) ? 4'b0010 :
               (state[2]) ? 4'b0011 :
               (state[3]) ? 4'b0100 :
               (state[4]) ? 4'b0101 :
               (state[5]) ? 4'b0110 :
               (state[6]) ? 4'b0111 :
               (state[7]) ? 4'b1000 :
               (state[8]) ? 4'b1001 :
               (state[9]) ? 4'b1010 : 4'b0000;

// State transitions
always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001;  // Reset to state 1
    end
    else begin
        // Rotate left with wrap-around
        state <= {state[8:0], state[9]};
    end
end

assign q = q_out;

endmodule