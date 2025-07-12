module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 4'd1;
        else
            q <= (q == 4'd10) ? 4'd1 : q + 1'b1;
    end

endmodule