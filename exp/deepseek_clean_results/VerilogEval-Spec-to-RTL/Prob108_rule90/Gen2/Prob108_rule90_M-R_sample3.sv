module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Compute next state with boundary conditions (0 for q[-1] and q[512])
    assign next_q = {1'b0, q[511:1]} ^ {q[510:0], 1'b0};

    // Update q on clock edge
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule