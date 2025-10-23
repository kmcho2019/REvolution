module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);

    integer i;
    always @(negedge clk) begin
        if (reset) begin
            // Reset q to 0x34 synchronously on negedge clk
            q <= 8'h34;
        end else begin
            // Update each bit individually
            for (i = 0; i < 8; i = i + 1) begin
                q[i] <= d[i];
            end
        end
    end

endmodule