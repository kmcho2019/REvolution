module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Create padded version for boundary conditions
wire [513:0] padded_q = {1'b0, q, 1'b0};

// Generate left and right neighbors
wire [511:0] left_neighbors = padded_q[512:1];  // q[i-1]
wire [511:0] right_neighbors = padded_q[513:2]; // q[i+1]

// Compute next state according to Rule 90
wire [511:0] next_q = left_neighbors ^ right_neighbors;

// Update state on clock edge
always @(posedge clk) begin
    if (load)
        q <= data;
    else
        q <= next_q;
end

endmodule