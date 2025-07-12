module TopModule (
    input           clk,
    input           reset,
    output reg [4:0] q
);

    wire feedback;
    wire [4:0] next_state;

    // feedback is XOR of taps and LSB q[0]
    // taps at bit 5 (q[4]) and bit 3 (q[2]) with q[0] as feedback base
    assign feedback = q[0] ^ q[2] ^ q[4];

    // compute next state combinationally
    assign next_state[0] = q[1];
    assign next_state[1] = q[2];
    assign next_state[2] = q[3] ^ q[0]; // tap at bit 3
    assign next_state[3] = q[4];
    assign next_state[4] = feedback;    // tap at bit 5

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // synchronous reset to 1
        end else begin
            q <= next_state;
        end
    end

endmodule