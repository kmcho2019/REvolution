module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

// One-hot state register (10 bits for states 1 through 10)
reg [9:0] state;

// State to binary output conversion
assign q = (state[0]) ? 4'b0001 :  // State 1
           (state[1]) ? 4'b0010 :  // State 2
           (state[2]) ? 4'b0011 :  // State 3
           (state[3]) ? 4'b0100 :  // State 4
           (state[4]) ? 4'b0101 :  // State 5
           (state[5]) ? 4'b0110 :  // State 6
           (state[6]) ? 4'b0111 :  // State 7
           (state[7]) ? 4'b1000 :  // State 8
           (state[8]) ? 4'b1001 :  // State 9
                        4'b1010;  // State 10

always @(posedge clk) begin
    if (reset) begin
        // Reset to state 1 (0000000001)
        state <= 10'b0000000001;
    end
    else begin
        // Circular shift left
        if (state[9]) begin
            // If in state 10, wrap around to state 1
            state <= 10'b0000000001;
        end
        else begin
            // Otherwise shift left
            state <= {state[8:0], 1'b0};
        end
    end
end

endmodule