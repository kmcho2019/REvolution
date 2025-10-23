module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin: bit_slice
        always @(posedge clk) begin
            if (reset) begin
                q[i] <= (i == 0);  // Initialize to 1 (LSB=1, others=0)
            end else begin
                case (i)
                    // Tap positions (32,22,2,1 in 0-based indexing: 31,21,1,0)
                    31: q[i] <= q[0];  // MSB gets q[0]
                    21: q[i] <= q[i+1] ^ q[0];  // Tap at 22 (21+1)
                    1:  q[i] <= q[i+1] ^ q[0];  // Tap at 2 (1+1)
                    0:  q[i] <= q[i+1] ^ q[0];  // Tap at 1 (0+1)
                    default: 
                        if (i == 30) q[i] <= q[31];  // Handle wrap-around for bit 31
                        else if (i < 31) q[i] <= q[i+1];  // Normal shift
                endcase
            end
        end
    end
endgenerate

endmodule