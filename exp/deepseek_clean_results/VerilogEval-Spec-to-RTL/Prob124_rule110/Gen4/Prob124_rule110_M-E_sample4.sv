module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] left_neighbor = {1'b0, q[511:1]};  // q[i-1], with left boundary = 0
    wire [511:0] right_neighbor = {q[510:0], 1'b0}; // q[i+1], with right boundary = 0
    
    wire [511:0] rule110_logic;
    
    // Rule 110 implemented with bitwise operations:
    // Next state = (~left & center) | (center & ~right) | (~left & right) | (left & center & ~right)
    assign rule110_logic = 
        ((~left_neighbor) & q) |          // (~left & center)
        (q & (~right_neighbor)) |         // (center & ~right)
        ((~left_neighbor) & right_neighbor) |  // (~left & right)
        (left_neighbor & q & (~right_neighbor));  // (left & center & ~right)

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= rule110_logic;
        end
    end

endmodule