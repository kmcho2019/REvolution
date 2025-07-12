module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Temporary extended state for boundary conditions
    wire [513:0] extended_state = {1'b0, q, 1'b0};
    
    // Shifted versions for neighbor access
    wire [511:0] left_neighbors = extended_state[512:1];  // q[i-1]
    wire [511:0] right_neighbors = extended_state[511:0]; // q[i+1]
    
    // Next state computation
    wire [511:0] next_state = left_neighbors ^ right_neighbors;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule