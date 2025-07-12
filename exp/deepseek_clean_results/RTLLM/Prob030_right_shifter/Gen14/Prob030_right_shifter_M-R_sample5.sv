module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,
    output wire [7:0] q
);

// Clock gating
wire gated_clk;
assign gated_clk = clk & enable;

// Combinational shift logic
wire [7:0] next_q;
assign next_q = {d, q[7:1]};

// Register implementation using DFFs
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : reg_gen
        dff dff_inst (
            .clk(gated_clk),
            .d(next_q[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule

// Basic D flip-flop module
module dff (
    input wire clk,
    input wire d,
    output reg q
);
always @(posedge clk) begin
    q <= d;
end
endmodule