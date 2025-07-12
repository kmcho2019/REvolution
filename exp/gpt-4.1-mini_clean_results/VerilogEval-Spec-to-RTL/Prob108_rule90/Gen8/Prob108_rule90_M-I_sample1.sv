module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    // Extended vector with zero padding on both ends for boundaries
    wire [513:0] padded_q = {1'b0, q, 1'b0};
    reg  [511:0] next_state;

    integer i;
    always @(*) begin
        // Compute next state for each cell: XOR of neighbors
        for (i = 0; i < 512; i = i + 1) begin
            next_state[i] = padded_q[i] ^ padded_q[i+2]; // left neighbor is padded_q[i], right neighbor is padded_q[i+2]
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule