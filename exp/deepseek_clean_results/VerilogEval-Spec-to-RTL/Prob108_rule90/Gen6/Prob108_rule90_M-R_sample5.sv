module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    reg [511:0] state;
    
    // Next state calculation with explicit boundary handling
    wire [511:0] next_state = {
        state[510] ^ 1'b0,                    // Leftmost cell (right neighbor is 0)
        state[509:1] ^ state[511:3],          // Middle cells
        1'b0 ^ state[1]                       // Rightmost cell (left neighbor is 0)
    };
    
    // Continuous state update with load condition
    assign state = load ? data : next_state;
    
    // Clocked state update
    always @(posedge clk) begin
        state <= state;  // This line ensures clocked behavior
    end
    
    // Direct output assignment
    assign q = state;

endmodule