module TopModule (
    input  wire        clk,
    input  wire        reset,
    output reg  [31:0] q
);

    reg feedback;
    reg [31:0] next_q;

    // Compute feedback and next state combinationally
    always @(*) begin
        feedback = q[0];
        next_q = q >> 1;
        // Apply feedback XOR to tapped bits
        next_q[31] = next_q[31] ^ feedback; // tap at bit 32
        next_q[21] = next_q[21] ^ feedback; // tap at bit 22
        next_q[1]  = next_q[1]  ^ feedback; // tap at bit 2
        next_q[0]  = next_q[0]  ^ feedback; // tap at bit 1
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule