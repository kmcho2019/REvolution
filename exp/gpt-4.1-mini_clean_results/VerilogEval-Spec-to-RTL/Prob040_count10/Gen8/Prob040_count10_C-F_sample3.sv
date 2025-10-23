module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire enable = (q != 4'd9);

    always @(posedge clk) begin
        if (reset)
            q <= 4'd0;
        else if (enable)
            q <= q + 4'd1;
        else
            q <= 4'd0;
    end

endmodule