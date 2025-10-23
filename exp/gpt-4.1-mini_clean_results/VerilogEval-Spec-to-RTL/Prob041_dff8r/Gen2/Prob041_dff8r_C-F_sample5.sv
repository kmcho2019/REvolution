module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    // Generate clock enable: update q only on reset or when d differs from q
    wire clk_en = reset | (d != q);

    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;
        else if (clk_en)
            q <= d;
        // else q holds its value, avoiding unnecessary toggles
    end

endmodule