module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    // Initialize out with zeros to prevent undefined values
    initial out = 32'b0;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            for (int i = 0; i < 32; i = i + 1) begin
                if (out[i] || (in[i] && !in[i])) begin
                    out[i] <= 1'b1;
                end
            end
        end
    end

endmodule