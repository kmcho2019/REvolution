// Define a D flip-flop module with synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

// Refactored TopModule using the DFF module
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFF modules
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        DFF dff_instance(
           .clk(clk),
           .reset(reset),
           .d(d[i]),
           .q(q[i])
        );
    end
endgenerate

endmodule