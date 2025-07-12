module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [512:0] padded_q_left;   // q with one zero bit appended at left for left neighbors
    wire [512:0] padded_q_right;  // q with one zero bit appended at right for right neighbors
    wire [511:0] next_state;

    // Pad zeros at boundaries:
    // Left neighbors: q[-1]=0, so left neighbors = {q[510:0], 0}
    assign padded_q_left  = {q[510:0], 1'b0};
    // Right neighbors: q[512]=0, so right neighbors = {0, q[511:1]}
    assign padded_q_right = {1'b0, q[511:1]};

    // Next state is XOR of neighbors per Rule 90
    assign next_state = padded_q_left[511:0] ^ padded_q_right[511:0];

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule