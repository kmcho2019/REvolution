module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// LFSR-style decade counter with taps at bits 3 and 1
// Sequence: 0,1,2,3,4,5,6,7,8,9,0...
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (slowena) begin
        case (q)
            4'b1001: q <= 4'b0000;  // Force wrap-around after 9
            default: begin
                // LFSR-style update with taps at bits 3 and 1
                q <= {q[2:0], q[3] ^ q[1]};
                // Correct any invalid states (10-15) to 0
                if (q > 4'b1001) q <= 4'b0000;
            end
        endcase
    end
end

endmodule