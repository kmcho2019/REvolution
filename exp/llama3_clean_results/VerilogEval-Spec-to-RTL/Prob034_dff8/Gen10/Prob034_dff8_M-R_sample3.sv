// DFF module
module DFF(
    input clk,
    input d,
    output reg q = 1'b0 // Initialize 'q' to zero
);

always @(posedge clk) begin
    q <= d; // Use non-blocking assignment for sequential logic
end

endmodule

// TopModule
module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin
        DFF dff_i(
           .clk(clk),
           .d(d[i]),
           .q(q[i])
        );
    end
endgenerate

endmodule