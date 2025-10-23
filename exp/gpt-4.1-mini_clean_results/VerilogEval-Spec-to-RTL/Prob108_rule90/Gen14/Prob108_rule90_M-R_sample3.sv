module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [513:0] padded_q;  // q padded with zero on both ends: q[-1]=0, q[512]=0
    wire [511:0] next_state;
    wire ce;

    // Pad q with zeros at both ends for boundary conditions
    assign padded_q = {1'b0, q, 1'b0};

    // Compute next state: each bit is XOR of left and right neighbors
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : compute_next
            assign next_state[i] = padded_q[i] ^ padded_q[i+2];
        end
    endgenerate

    // Clock enable: update if loading or if next_state differs from current q
    assign ce = load | |(next_state ^ q);

    // Sequential update of state q
    always @(posedge clk) begin
        if (ce) begin
            if (load)
                q <= data;
            else
                q <= next_state;
        end
    end
endmodule