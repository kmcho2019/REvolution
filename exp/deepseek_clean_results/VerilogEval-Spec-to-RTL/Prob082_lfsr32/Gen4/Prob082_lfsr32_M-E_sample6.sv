module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Stage 1: Feedback computation registers
reg feedback;
reg [31:0] next_q;

// Stage 2: Shift and update registers
always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
        feedback <= 1'b0;
        next_q <= 32'h0;
    end
    else begin
        // Stage 1: Compute all XOR operations in parallel
        feedback <= q[0];
        next_q[31] <= q[0];  // New MSB
        next_q[30:22] <= q[31:23];  // Upper bits shift
        next_q[21] <= q[22] ^ q[0];  // Tap at 22
        next_q[20:2] <= q[21:3];  // Middle bits shift
        next_q[1] <= q[2] ^ q[0];  // Tap at 2
        next_q[0] <= q[1] ^ q[0];  // Tap at 1

        // Stage 2: Update the output register
        q <= next_q;
    end
end

endmodule