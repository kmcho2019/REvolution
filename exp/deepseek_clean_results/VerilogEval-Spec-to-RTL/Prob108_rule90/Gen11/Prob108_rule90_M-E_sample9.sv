module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

reg [511:0] left_neighbor;
reg [511:0] right_neighbor;
wire [511:0] next_q;

// Shift register implementation for neighbors
always @(posedge clk) begin
    if (load) begin
        q <= data;
        left_neighbor <= {1'b0, data[511:1]};  // Right shift with 0 fill
        right_neighbor <= {data[510:0], 1'b0}; // Left shift with 0 fill
    end else begin
        q <= next_q;
        left_neighbor <= {1'b0, next_q[511:1]};
        right_neighbor <= {next_q[510:0], 1'b0};
    end
end

// Parallel XOR computation
assign next_q = left_neighbor ^ right_neighbor;

endmodule