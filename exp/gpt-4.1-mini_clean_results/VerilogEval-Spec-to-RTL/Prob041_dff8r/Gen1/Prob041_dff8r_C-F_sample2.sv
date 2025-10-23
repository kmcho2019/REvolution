module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);
    wire load_enable;
    // Enable loading when reset is asserted or input data differs from output
    assign load_enable = reset | (d != q);

    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;
        else if (load_enable)
            q <= d;
    end
endmodule