module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] left_neighbors;
    wire [511:0] right_neighbors;
    wire [511:0] next_state;

    // Left neighbors: q shifted right by 1, MSB filled with 0 (q[-1]=0)
    assign left_neighbors = {1'b0, q[511:1]};

    // Right neighbors: q shifted left by 1, LSB filled with 0 (q[512]=0)
    assign right_neighbors = {q[510:0], 1'b0};

    // Next state is XOR of neighbors
    assign next_state = left_neighbors ^ right_neighbors;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end
endmodule