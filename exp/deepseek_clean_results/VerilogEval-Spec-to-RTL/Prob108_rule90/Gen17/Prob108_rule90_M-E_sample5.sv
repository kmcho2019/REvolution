module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

reg [511:0] left_neighbors;
reg [511:0] right_neighbors;
wire [511:0] next_q;

// Shift register implementation for neighbor capture
always @(posedge clk) begin
    if (load) begin
        left_neighbors <= {data[510:0], 1'b0};  // Left shift with zero insert
        right_neighbors <= {1'b0, data[511:1]}; // Right shift with zero insert
        q <= data;
    end else begin
        // Update shift registers with current state
        left_neighbors <= {q[510:0], 1'b0};
        right_neighbors <= {1'b0, q[511:1]};
        
        // Update main register with next state
        q <= next_q;
    end
end

// Parallel XOR of neighbors
assign next_q = left_neighbors ^ right_neighbors;

endmodule