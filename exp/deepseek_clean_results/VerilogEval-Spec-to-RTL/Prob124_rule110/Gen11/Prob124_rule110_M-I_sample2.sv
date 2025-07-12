module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;

    // Optimized Rule 110 logic: next = center ^ (left & ~right)
    // This matches all cases of the truth table
    assign next_q[0] = q[0] ^ (1'b0 & ~1'b0);  // Left boundary = 0
    
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : rule110
            // Optimized Rule 110 logic
            assign next_q[i] = q[i] ^ (q[i+1] & ~q[i-1]);
        end
    endgenerate
    
    assign next_q[511] = q[511] ^ (1'b0 & ~q[510]);  // Right boundary = 0

    // State transition with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (next_q != q) begin  // Only update if state changes
            q <= next_q;
        end
    end

endmodule