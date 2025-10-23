module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] next_state;

    // Boundary cells assumed zero outside the array
    // next_state[i] = q[i-1] ^ q[i+1], with q[-1]=0 and q[512]=0
    assign next_state[0]   = 1'b0       ^ q[1];
    assign next_state[511] = q[510]     ^ 1'b0;

    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : compute_next
            assign next_state[i] = q[i-1] ^ q[i+1];
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule