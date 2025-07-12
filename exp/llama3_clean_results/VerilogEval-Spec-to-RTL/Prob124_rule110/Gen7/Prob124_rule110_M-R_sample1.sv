module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign next_state = {
    // Handle the leftmost cell (i = 0)
    1'b0, // Left neighbor of leftmost cell is always 0
    
    // Calculate next state for cells 1 to 510
    (current_state[1] & ~current_state[0]) | 
    (~current_state[1] & current_state[0] & ~current_state[2]) | 
    (~current_state[1] & ~current_state[0] & current_state[2]) | 
    (~current_state[1] & ~current_state[0] & ~current_state[2]),
    
    // Handle the rightmost cell (i = 511)
    1'b0  // Right neighbor of rightmost cell is always 0
};

assign q = current_state;

endmodule