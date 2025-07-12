module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Reset value generator
wire [7:0] reset_val = 8'b00110100;  // 0x34

// Individual DFF instances
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        reg dff;
        always @(negedge clk) begin
            if (reset) begin
                dff <= reset_val[i];
            end else begin
                dff <= d[i];
            end
        end
        assign q[i] = dff;
    end
endgenerate

endmodule