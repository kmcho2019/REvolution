module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

reg [31:0] next_q;
reg [2:0] xor_results; // Stores XOR results for taps 22, 2, and 1

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
        xor_results <= 3'b0;
    end else begin
        // Stage 1: Compute XOR results in parallel
        xor_results[0] <= q[22] ^ q[0]; // Tap 22
        xor_results[1] <= q[2] ^ q[0];  // Tap 2
        xor_results[2] <= q[1] ^ q[0];  // Tap 1
        
        // Stage 2: Perform the shift with pre-computed XOR values
        q <= {q[0], q[31:23], xor_results[0], q[21:3], xor_results[1], xor_results[2]};
    end
end

endmodule