module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    wire load_enable = (d != q);

    always @(posedge clk) begin
        if (load_enable)
            q <= d;
    end

    // Optional: initialize q to zero for simulation clarity
    // synthesis translate_off
    initial begin
        q = 8'b0;
    end
    // synthesis translate_on

endmodule