module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    wire enable;
    assign enable = reset | (d != q);

    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;
        else if (enable)
            q <= d;
    end

endmodule