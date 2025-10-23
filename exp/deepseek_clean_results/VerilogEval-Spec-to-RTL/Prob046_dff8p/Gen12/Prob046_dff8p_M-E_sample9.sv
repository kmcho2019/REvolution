module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Individual DFF instantiations with specific reset values
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        // Reset value for each bit (0x34 = 8'b00110100)
        localparam RST_VAL = (i == 2 || i == 3 || i == 5) ? 1'b1 : 1'b0;
        
        DFF_NEG dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i]),
            .rst_val(RST_VAL)
        );
    end
endgenerate

endmodule

// Negative-edge triggered DFF with synchronous reset
module DFF_NEG (
    input clk,
    input reset,
    input d,
    output reg q,
    input rst_val
);
always @(negedge clk) begin
    if (reset) begin
        q <= rst_val;
    end else begin
        q <= d;
    end
end
endmodule