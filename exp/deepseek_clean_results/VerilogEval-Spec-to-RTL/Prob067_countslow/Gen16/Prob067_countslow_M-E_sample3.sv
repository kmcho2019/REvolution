module TopModule (
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [9:0] state; // One-hot states for 0-9

// State encoding to binary output
assign q = (state[0]) ? 4'b0000 :
           (state[1]) ? 4'b0001 :
           (state[2]) ? 4'b0010 :
           (state[3]) ? 4'b0011 :
           (state[4]) ? 4'b0100 :
           (state[5]) ? 4'b0101 :
           (state[6]) ? 4'b0110 :
           (state[7]) ? 4'b0111 :
           (state[8]) ? 4'b1000 :
                        4'b1001; // state[9]

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001; // Reset to state 0
    end
    else if (slowena) begin
        // Circular shift left with wrap-around
        state <= {state[8:0], state[9]};
    end
end

endmodule