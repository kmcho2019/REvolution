module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] q_next;

    // Boundary bits explicitly assigned to avoid conditional expressions in generate loop
    assign q_next[0]   = 1'b0 ^ q[1];           // left neighbor = 0
    assign q_next[511] = q[510] ^ 1'b0;          // right neighbor = 0

    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : update_inner_bits
            assign q_next[i] = q[i-1] ^ q[i+1];
        end
    endgenerate

    // Enable updating q only when load=0; avoids toggling q unnecessarily
    wire update_enable = ~load;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (update_enable) begin
            q <= q_next;
        end
        // else retain previous q (no toggling)
    end

endmodule