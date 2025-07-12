module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Base DFF module with parameterized reset value
module DFF_NEGEDGE #(parameter RESET_VAL = 0) (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(negedge clk) begin
        if (reset) begin
            q <= RESET_VAL;
        end else begin
            q <= d;
        end
    end
endmodule

// Instantiate 8 DFFs with corresponding reset bits from 0x34
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        DFF_NEGEDGE #(.RESET_VAL(8'h34[i])) dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule