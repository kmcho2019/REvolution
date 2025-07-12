module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Define reset values for each bit (0x34 = 00110100)
localparam [7:0] RESET_VAL = 8'b00110100;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        always @(negedge clk) begin
            if (reset) begin
                q[i] <= RESET_VAL[i];
            end else begin
                q[i] <= d[i];
            end
        end
    end
endgenerate

endmodule