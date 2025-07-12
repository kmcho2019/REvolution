module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions as bits: 31, 21, 1, 0 (0-based indexing)
    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else begin
            if (q[0])
                q <= (q >> 1) ^ (32'h80000001 | 32'h00200000);
            else
                q <= q >> 1;
        end
    end

endmodule