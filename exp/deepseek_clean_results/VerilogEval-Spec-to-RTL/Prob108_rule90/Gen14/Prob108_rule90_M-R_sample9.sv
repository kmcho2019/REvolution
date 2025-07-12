module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    wire [513:0] extended_q = {1'b0, q, 1'b0};  // Handle boundaries with 0s

    // Rule 90: next state is XOR of left and right neighbors
    assign next_q = extended_q[512:1] ^ extended_q[511:0];

    // Synchronous update
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule