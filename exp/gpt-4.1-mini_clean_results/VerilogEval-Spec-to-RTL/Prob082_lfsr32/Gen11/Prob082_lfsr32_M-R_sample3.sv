module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    wire [31:0] next_q;

    // Compute next state combinationally:
    // Shift right by one: next_q[30:0] = q[31:1]
    // Insert feedback at MSB (bit 31)
    // XOR feedback with tapped bits (31, 21, 1, 0) before shifting
    assign next_q[31] = feedback;
    assign next_q[30:22] = q[31:23];
    assign next_q[21] = q[22] ^ feedback;
    assign next_q[20:2] = q[21:3];
    assign next_q[1] = q[2] ^ feedback;
    assign next_q[0] = q[1] ^ feedback;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule