module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [9:0] state;  // One-hot states for 1-10 (bit 0 = 1, bit 9 = 10)
wire [3:0] priority_encoded;

// Priority encoder for one-hot to binary conversion
assign priority_encoded = 
    state[0] ? 4'b0001 :  // 1
    state[1] ? 4'b0010 :  // 2
    state[2] ? 4'b0011 :  // 3
    state[3] ? 4'b0100 :  // 4
    state[4] ? 4'b0101 :  // 5
    state[5] ? 4'b0110 :  // 6
    state[6] ? 4'b0111 :  // 7
    state[7] ? 4'b1000 :  // 8
    state[8] ? 4'b1001 :  // 9
    4'b1010;              // 10

assign q = priority_encoded;

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001;  // Reset to state 1
    end
    else begin
        state <= {state[8:0], state[9]};  // Rotate left
    end
end

endmodule