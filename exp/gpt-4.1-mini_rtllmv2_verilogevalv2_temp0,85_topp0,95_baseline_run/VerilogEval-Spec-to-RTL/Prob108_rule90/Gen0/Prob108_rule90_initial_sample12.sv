module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] next_state;

    // Compute next state for each cell according to Rule 90
    // For boundary cells, neighbors outside are zero
    assign next_state[0] = q[1];                       // left neighbor = 0, right neighbor = q[1], XOR = 0 ^ q[1]
    assign next_state[511] = q[510];                   // left neighbor = q[510], right neighbor = 0, XOR = q[510] ^ 0
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : RULE90_LOOP
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