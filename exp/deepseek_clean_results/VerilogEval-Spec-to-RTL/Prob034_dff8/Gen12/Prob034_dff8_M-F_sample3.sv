module TopModule (
    input clk,
    input reset_n,  // Active-low synchronous reset
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        DFF dff (
            .clk(clk),
            .reset_n(reset_n),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule

// D flip-flop module with synchronous reset
module DFF (
    input clk,
    input reset_n,  // Active-low reset
    input d,
    output reg q
);
always @(posedge clk) begin
    if (!reset_n) q <= 1'b0;  // Synchronous reset
    else q <= d;
end
endmodule