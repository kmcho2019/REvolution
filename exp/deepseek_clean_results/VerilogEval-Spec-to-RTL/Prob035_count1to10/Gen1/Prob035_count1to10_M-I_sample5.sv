module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [9:0] state;  // One-hot state: bit 0=1, bit 1=2,... bit 9=10

// One-hot to binary conversion
assign q = (state[0]) ? 4'b0001 :
           (state[1]) ? 4'b0010 :
           (state[2]) ? 4'b0011 :
           (state[3]) ? 4'b0100 :
           (state[4]) ? 4'b0101 :
           (state[5]) ? 4'b0110 :
           (state[6]) ? 4'b0111 :
           (state[7]) ? 4'b1000 :
           (state[8]) ? 4'b1001 :
           (state[9]) ? 4'b1010 : 4'b0001;

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001;  // Reset to state 1
    end
    else begin
        // Circular shift left
        if (state[9]) begin      // If in state 10
            state <= 10'b0000000001;  // Wrap to state 1
        end
        else begin
            state <= {state[8:0], 1'b0};  // Shift left
        end
    end
end

endmodule