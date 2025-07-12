module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | 1;
    wire feedback;

    // Compute feedback bit as XOR of q[0] and taps at specified positions
    assign feedback = q[0];

    wire [31:0] next_q;
    // Next state calculation using Galois LFSR logic:
    // Shift right by 1, and XOR bits at tap positions with feedback
    assign next_q = (q >> 1) ^ (TAP_MASK & {32{feedback}});

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule