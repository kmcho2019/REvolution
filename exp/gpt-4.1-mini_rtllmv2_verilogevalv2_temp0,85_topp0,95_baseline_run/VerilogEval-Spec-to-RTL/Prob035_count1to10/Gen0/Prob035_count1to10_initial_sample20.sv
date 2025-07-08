module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd1;  // reset to 1
        end else begin
            if (q == 4'd10) begin
                q <= 4'd1;  // wrap back to 1 after 10
            end else begin
                q <= q + 4'd1;  // increment count
            end
        end
    end

endmodule