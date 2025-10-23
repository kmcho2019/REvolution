module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left_neighbor  = {1'b0, q[511:1]};  // Shift right with 0 boundary
    wire [511:0] right_neighbor = {q[510:0], 1'b0};  // Shift left with 0 boundary
    wire [511:0] center = q;

    // Rule 110 implementation using parallel bitwise operations
    // The logic is: (left & ~(center & right)) | (~left & (center | right))
    // Which correctly implements the truth table when expanded
    wire [511:0] next_q = (left_neighbor & ~(center & right_neighbor)) | 
                         (~left_neighbor & (center | right_neighbor));

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule