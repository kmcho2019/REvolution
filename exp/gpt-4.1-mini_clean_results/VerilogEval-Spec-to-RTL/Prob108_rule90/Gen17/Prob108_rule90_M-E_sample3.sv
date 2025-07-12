module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Create left neighbors vector:
    // Left neighbor of q[0] is 0, so pad 0 at LSB side, shift q right by 1
    wire [511:0] left_neighbors = {q[510:0], 1'b0};
    // Create right neighbors vector:
    // Right neighbor of q[511] is 0, so pad 0 at MSB side, shift q left by 1
    wire [511:0] right_neighbors = {1'b0, q[511:1]};

    // Next state is XOR of left and right neighbors
    wire [511:0] next_state = left_neighbors ^ right_neighbors;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule