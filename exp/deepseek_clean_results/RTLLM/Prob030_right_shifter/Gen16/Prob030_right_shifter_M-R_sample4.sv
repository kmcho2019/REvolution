module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,
    output wire [7:0] q
);

wire gated_clk = clk & enable;
wire [7:0] q_next;

// Shift operation implemented with explicit wiring
assign q_next = {d, q[7:1]};

// Sequential element using explicit instantiation
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : shift_reg
        dff dff_inst (
            .clk(gated_clk),
            .d(q_next[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule

// Basic D flip-flop module for explicit instantiation
module dff (
    input wire clk,
    input wire d,
    output reg q
);
always @(posedge clk) begin
    q <= d;
end
endmodule