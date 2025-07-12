module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

// One-hot state register (10 states)
reg [9:0] state;

// Binary output encoder
wire [3:0] q = 
    (state[0]) ? 4'b0001 :  // 1
    (state[1]) ? 4'b0010 :  // 2
    (state[2]) ? 4'b0011 :  // 3
    (state[3]) ? 4'b0100 :  // 4
    (state[4]) ? 4'b0101 :  // 5
    (state[5]) ? 4'b0110 :  // 6
    (state[6]) ? 4'b0111 :  // 7
    (state[7]) ? 4'b1000 :  // 8
    (state[8]) ? 4'b1001 :  // 9
                 4'b1010;  // 10

always @(posedge clk) begin
    if (reset) begin
        // Reset to state 1 (0000000001)
        state <= 10'b0000000001;
    end else begin
        // Circular shift left
        state <= {state[8:0], state[9]};
    end
end

endmodule