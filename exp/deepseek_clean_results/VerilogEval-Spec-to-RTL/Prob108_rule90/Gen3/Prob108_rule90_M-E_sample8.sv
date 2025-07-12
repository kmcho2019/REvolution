module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Left and right neighbor selection with boundary handling
    wire [511:0] left_neighbors = {1'b0, q[511:1]};  // Left shift with 0 boundary
    wire [511:0] right_neighbors = {q[510:0], 1'b0}; // Right shift with 0 boundary

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