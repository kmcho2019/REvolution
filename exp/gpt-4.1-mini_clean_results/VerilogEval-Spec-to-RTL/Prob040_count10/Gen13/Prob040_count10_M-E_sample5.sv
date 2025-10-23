module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else begin
            // If q is 9, wrap around to 0; else increment
            q <= (q == 4'd9) ? 4'd0 : q + 4'd1;
        end
    end

endmodule