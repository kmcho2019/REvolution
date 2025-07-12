module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Correct tap mask for positions 32,22,2,1 (1-based) = bits 31,21,1,0 (0-based)
localparam TAP_MASK = 32'b10000000000100000000000000000011;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Galois LFSR implementation:
        // 1. Right shift with feedback at MSB
        // 2. XOR tapped bits with feedback (q[0])
        q <= {q[0], q[31:1]};
        if (q[0]) begin
            q <= {q[0], q[31:1]} ^ TAP_MASK;
        end
    end
end

endmodule