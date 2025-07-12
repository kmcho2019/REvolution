module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    // Pad current state with zero boundaries on both ends
    wire [513:0] padded_q = {1'b0, q, 1'b0};

    // Compute next state: each bit = XOR of left and right neighbors
    wire [511:0] next_state;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_calc
            assign next_state[i] = padded_q[i] ^ padded_q[i+2];
        end
    endgenerate

    // Sequential logic: load data or advance to next state on clk posedge
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule