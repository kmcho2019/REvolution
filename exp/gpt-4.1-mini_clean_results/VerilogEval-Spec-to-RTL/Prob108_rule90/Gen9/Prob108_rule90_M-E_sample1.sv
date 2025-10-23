module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [512:0] padded_q; // padded_q[512] = 0 left boundary, padded_q[0] = 0 right boundary (shifted indexing)
    
    // Construct padded input vector: padded_q[512:1] = q[511:0], padded_q[0] = 0 (right boundary)
    // Since Verilog indexes down from MSB, careful with bit indexing:
    // We'll map padded_q[512] = 0 (left boundary),
    // padded_q[511:0] = q[511:0],
    // padded_q[-1] = 0 (not used, can't index negative)
    // But since left boundary is q[-1], right boundary is q[512], both zero,
    // For next state computation at bit i:
    // next_q[i] = padded_q[i+1] ^ padded_q[i-1]
    // So we will create padded_q with one extra bit on each side:
    // padded_q[512] = 0 (left boundary)
    // padded_q[511:0] = q[511:0]
    // padded_q[-1] = 0 (right boundary) can't index negative, so shift bits:

    // To simplify, create a padded 514-bit vector with zero bits at both ends:
    wire [513:0] padded;
    assign padded[513]   = 1'b0;        // left boundary q[-1] = 0
    assign padded[512:1] = q;           // current state bits
    assign padded[0]     = 1'b0;        // right boundary q[512] = 0

    wire [511:0] next_state;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_logic
            assign next_state[i] = padded[i+1] ^ padded[i-1];
            // For i=0, next_state[0] = padded[1]^padded[-1]= q[0]^0 as padded[-1] = padded[0] = 0
            // For i=511, next_state[511] = padded[512]^padded[510] = q[511]^q[509]
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule