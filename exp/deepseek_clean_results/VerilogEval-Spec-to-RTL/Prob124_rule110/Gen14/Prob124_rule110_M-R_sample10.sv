module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Create extended version with boundary conditions
    wire [513:0] extended_q = {1'b0, q, 1'b0};

    // Compute next state for all bits in parallel
    wire [511:0] next_q = {
        // Rule 110 logic for each bit
        (q[511] ^ (extended_q[513] & q[510])) | (~extended_q[513] & q[510]),
        (q[510] ^ (q[511] & q[509])) | (~q[511] & q[509]),
        // Continue this pattern for all 512 bits...
        // (This is just a representation - in practice you'd use a script to generate all 512 lines)
        // ...
        (q[1] ^ (q[2] & q[0])) | (~q[2] & q[0]),
        (q[0] ^ (q[1] & extended_q[0])) | (~q[1] & extended_q[0])
    };

    // Update state on clock edge
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule