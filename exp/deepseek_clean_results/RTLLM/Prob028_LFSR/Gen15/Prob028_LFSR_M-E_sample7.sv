module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

reg [1:0] warmup_count;
wire enable = (warmup_count == 2'b11);  // Enable after 4 cycles

// Complex feedback: (out[3] XNOR out[1]) XOR (out[2] NOR out[0])
wire feedback = ((out[3] ~^ out[1]) ^ (~(out[2] | out[0]));

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0001;          // Initialize to non-zero state
        warmup_count <= 2'b00;   // Reset warm-up counter
    end else begin
        if (!enable) begin
            warmup_count <= warmup_count + 1;  // Count warm-up cycles
        end
        
        if (enable) begin
            // Shift left and insert feedback at LSB
            out <= {out[2:0], feedback};
        end else begin
            // During warm-up, rotate bits to mix them
            out <= {out[2:0], out[3]};
        end
    end
end

endmodule