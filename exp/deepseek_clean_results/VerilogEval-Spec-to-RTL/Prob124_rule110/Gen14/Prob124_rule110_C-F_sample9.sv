module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;

    // Handle left boundary (q[511] has no right neighbor)
    assign next_q[511] = (q[511] & ~q[510]) | (~q[511] & q[510]) | (~q[511]);

    // Handle right boundary (q[0] has no left neighbor)
    assign next_q[0] = (q[1] & q[0]) | (~q[1] & q[0]) | (~q[1] & ~q[0] & q[0]);

    // Generate next state for middle bits
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : rule110
            // Optimized Rule 110 logic - all cases where next state is 1
            assign next_q[i] = (q[i+1] & q[i] & ~q[i-1]) |  // 110
                              (q[i+1] & ~q[i] & q[i-1]) |   // 101
                              (~q[i+1] & q[i]) |            // 011 or 010
                              (~q[i+1] & q[i-1]);           // 001
        end
    endgenerate

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule