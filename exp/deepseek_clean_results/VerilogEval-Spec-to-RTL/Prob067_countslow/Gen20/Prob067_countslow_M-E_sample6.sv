module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// LFSR taps for maximal length sequence (x^4 + x^3 + 1)
wire feedback = q[3] ^ q[2];

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000; // Reset to 0
    end
    else if (slowena) begin
        if (q == 4'b1001) begin
            q <= 4'b0000; // Wrap around from 9 to 0
        end
        else if (q == 4'b1010) begin
            q <= 4'b0000; // Correct invalid state 10 to 0
        end
        else begin
            // Standard LFSR operation
            q <= {q[2:0], feedback};
        end
    end
end

endmodule