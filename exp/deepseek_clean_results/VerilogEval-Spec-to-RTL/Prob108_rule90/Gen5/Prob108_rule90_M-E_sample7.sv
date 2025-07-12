module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    reg [511:0] state;
    wire [511:0] next_state;
    
    // Create shifted versions for neighbor alignment
    wire [511:0] left_neighbors = {state[510:0], 1'b0};  // Right shift (left neighbors)
    wire [511:0] right_neighbors = {1'b0, state[511:1]};  // Left shift (right neighbors)
    
    // Compute next state as XOR of neighbors
    assign next_state = left_neighbors ^ right_neighbors;
    
    // Sequential logic with load
    always @(posedge clk) begin
        if (load) begin
            state <= data;
        end else begin
            state <= next_state;
        end
    end
    
    // Output assignment
    assign q = state;

endmodule