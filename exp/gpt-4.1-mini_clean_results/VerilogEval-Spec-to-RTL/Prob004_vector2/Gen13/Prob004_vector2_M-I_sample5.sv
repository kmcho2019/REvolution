module TopModule (
    input             clk,
    input      [31:0] in,
    output reg [31:0] out
);

    // On rising clock edge, register the byte-reversed input to output
    always @(posedge clk) begin
        out <= {in[7:0], in[15:8], in[23:16], in[31:24]};
    end

endmodule