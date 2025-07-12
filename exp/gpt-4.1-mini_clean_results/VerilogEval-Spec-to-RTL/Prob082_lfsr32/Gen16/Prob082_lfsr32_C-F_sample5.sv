module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= (q >> 1) ^ ({32{q[0]}} & 32'h80200003);
        end
    end

endmodule