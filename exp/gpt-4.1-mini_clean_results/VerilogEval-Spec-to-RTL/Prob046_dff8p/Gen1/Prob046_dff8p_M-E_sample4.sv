module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_array
        always @(negedge clk) begin
            if (reset)
                // Load bit i of 0x34 (0b00110100)
                q[i] <= 8'h34[i];
            else
                q[i] <= d[i];
        end
    end
endgenerate

endmodule