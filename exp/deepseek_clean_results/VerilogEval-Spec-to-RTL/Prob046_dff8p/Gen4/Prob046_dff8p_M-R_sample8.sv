module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Individual DFF instantiations
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        // Reset value is bit i of 0x34 (00110100)
        wire reset_val = (i == 2 || i == 3 || i == 5) ? 1'b1 : 1'b0;
        
        // Negative-edge triggered DFF with synchronous reset
        dff_neg dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i]),
            .reset_val(reset_val)
        );
    end
endgenerate

endmodule

// Negative-edge triggered DFF with synchronous reset
module dff_neg (
    input clk,
    input reset,
    input d,
    output reg q,
    input reset_val
);
always @(negedge clk) begin
    if (reset) begin
        q <= reset_val;
    end else begin
        q <= d;
    end
end
endmodule