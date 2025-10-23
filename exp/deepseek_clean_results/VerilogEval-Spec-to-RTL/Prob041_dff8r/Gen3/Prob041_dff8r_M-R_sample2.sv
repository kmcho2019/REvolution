module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

wire [7:0] next_q;

// Combinational logic for reset
assign next_q = reset ? 8'b0 : d;

// Sequential elements (8 DFFs)
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        DFF dff_inst (
            .clk(clk),
            .d(next_q[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule

// D Flip-flop primitive
module DFF (
    input clk,
    input d,
    output reg q
);
always @(posedge clk) begin
    q <= d;
end
endmodule