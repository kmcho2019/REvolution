module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Compute next state for each cell based on Rule 90
    // Boundary neighbors (q[-1] and q[512]) are zero
    assign next_q[0] = q[1];                     // q[-1] = 0, so next_q[0] = 0 ^ q[1] = q[1]
    assign next_q[511] = q[510];                 // q[512] = 0, so next_q[511] = q[510] ^ 0 = q[510]
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : next_state_gen
            assign next_q[i] = q[i-1] ^ q[i+1];
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule