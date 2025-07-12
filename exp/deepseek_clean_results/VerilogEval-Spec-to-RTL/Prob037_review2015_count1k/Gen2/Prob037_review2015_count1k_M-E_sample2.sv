module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

// Custom LFSR taps for 1000 unique states (0-999)
wire feedback = q[9] ^ q[6] ^ q[3] ^ q[0];

always @(posedge clk) begin
    if (reset) begin
        q <= 10'd0;
    end else begin
        // Special case to handle wrap-around from 999 to 0
        if (q == 10'd999) begin
            q <= 10'd0;
        end else begin
            // Normal LFSR operation
            q <= {q[8:0], feedback};
        end
    end
end

endmodule