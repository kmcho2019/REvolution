module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Neighbor vectors with boundary conditions (0 for out-of-range)
    wire [511:0] left_neighbor  = {1'b0, q[511:1]};  // q[i+1] with left boundary
    wire [511:0] right_neighbor = {q[510:0], 1'b0};  // q[i-1] with right boundary

    // Combinational next state calculation
    wire [511:0] next_q;
    
    // Implement Rule 110 using case-equivalent logic
    assign next_q = (~left_neighbor & (q | right_neighbor)) |  // Cases where left=0
                    (left_neighbor & q & ~right_neighbor) |    // 110 case
                    (left_neighbor & ~q & right_neighbor);     // 101 case

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule