module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

wire rotate_en = |ena;  // Enable rotation when ena != 00
wire rotate_dir = ena[1]; // 1 for left, 0 for right

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (rotate_en) begin
        // Split into two 50-bit chunks for better timing
        if (rotate_dir) begin // Left rotate
            q <= {q[98:0], q[99]};
        end else begin        // Right rotate
            q <= {q[0], q[99:1]};
        end
    end
    // Implicit else: q retains value (no clock gating shown for simplicity)
end

endmodule