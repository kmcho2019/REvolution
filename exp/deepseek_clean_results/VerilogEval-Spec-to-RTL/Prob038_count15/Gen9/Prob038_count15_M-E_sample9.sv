module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] lfsr;

assign q = lfsr;

always @(posedge clk) begin
    if (reset) begin
        lfsr <= 4'b0001;  // Initialize to non-zero value
    end else begin
        // Standard LFSR feedback for polynomial x^4 + x^3 + 1
        lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
        
        // Special case to include all-zero state in sequence
        if (lfsr == 4'b0001) begin
            lfsr <= 4'b0000;
        end else if (lfsr == 4'b0000) begin
            lfsr <= 4'b0001;
        end
    end
end

endmodule