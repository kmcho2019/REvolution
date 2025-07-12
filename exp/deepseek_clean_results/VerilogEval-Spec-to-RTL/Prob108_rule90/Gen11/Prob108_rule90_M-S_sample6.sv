module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_state;
    
    // Left neighbors (q[i-1]) with boundary condition (q[-1] = 0)
    wire [511:0] left_neighbors = {q[510:0], 1'b0};
    
    // Right neighbors (q[i+1]) with boundary condition (q[512] = 0)
    wire [511:0] right_neighbors = {1'b0, q[511:1]};
    
    // Rule 90: next state is XOR of left and right neighbors
    assign next_state = left_neighbors ^ right_neighbors;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule