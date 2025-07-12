module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

reg [31:0] q_next;
reg [2:0] xor_results;
wire clk_gated = |{q[21:3]};  // Clock gating signal

always @(*) begin
    xor_results[0] = q[22] ^ q[0];
    xor_results[1] = q[2] ^ q[0];
    xor_results[2] = q[1] ^ q[0];
    
    q_next = {q[0], q[31:23], xor_results[0], q[21:3], xor_results[1], xor_results[2]};
end

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        if (clk_gated) begin
            q[21:3] <= q[21:3];  // Only update if needed
        end
        q[31:22] <= q_next[31:22];
        q[2:0] <= q_next[2:0];
    end
end

endmodule