module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= (q >> 1) ^ (q[0] ? 32'h80200003 : 32'b0);
    end

endmodule