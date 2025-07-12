module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    wire [511:0] next_state;

    // Pad q with zeros on both ends for boundary conditions
    wire [513:0] padded_q = {1'b0, q, 1'b0};

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_next_state
            assign next_state[i] = padded_q[i] ^ padded_q[i+2];
            // Note: padded_q[i] = q[i-1] with offset, padded_q[i+2] = q[i+1]
            // Because padded_q = {0, q[511:0], 0}
            // Indexing: padded_q[0] = 0 = q[-1]
            // padded_q[1] = q[0]
            // So q[i-1] = padded_q[i]
            //     q[i+1] = padded_q[i+2]
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule