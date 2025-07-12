module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;

    // Boundary-extended version of q with zeros on both ends
    wire [513:0] extended_q = {1'b0, q, 1'b0};

    // Calculate next state for all bits in parallel
    assign next_q[511:0] = 
        // Rule 110 implementation
        (extended_q[512:1] & extended_q[511:0] & ~extended_q[510:511]) |  // 110 -> 1
        (extended_q[512:1] & ~extended_q[511:0] & extended_q[510:511]) |  // 101 -> 1
        (~extended_q[512:1] & extended_q[511:0]) |                      // 011/010 -> 1
        (~extended_q[512:1] & extended_q[510:511]);                      // 001 -> 1

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule