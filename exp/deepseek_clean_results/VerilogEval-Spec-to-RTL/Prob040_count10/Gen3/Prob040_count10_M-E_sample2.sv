module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Custom LFSR implementation for decade counter
// States: 0000(0), 0001(1), 0011(3), 0111(7), 1111(15->5), 1010(10->2), 
//         0101(5), 1011(11->3), 0110(6), 1101(13->1), then back to 0000

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;  // Reset to 0
    end
    else begin
        case (q)
            4'b1101: q <= 4'b0000;  // After 13 (mapped to 9), reset to 0
            default: begin
                // LFSR operation with polynomial x^4 + x^3 + 1
                q <= {q[2:0], q[3] ^ q[2]};
            end
        endcase
    end
end

endmodule