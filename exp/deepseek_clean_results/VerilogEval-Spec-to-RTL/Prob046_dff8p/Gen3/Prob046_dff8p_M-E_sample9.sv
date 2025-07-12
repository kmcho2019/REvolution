module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Internal reset value register (initialized to 0x34)
reg [7:0] reset_value = 8'h34;

// Generate individual DFFs with synchronous reset
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        always @(negedge clk) begin
            if (reset) begin
                q[i] <= reset_value[i];
            end
            else begin
                q[i] <= d[i];
            end
        end
    end
endgenerate

endmodule