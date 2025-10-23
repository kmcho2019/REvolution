module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        DFF dff (
            .clk(clk),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule

// Basic D flip-flop module without reset
module DFF (
    input clk,
    input d,
    output reg q
);
// synthesis translate_off
initial q = 1'b0;  // Simulation initialization
// synthesis translate_on

always @(posedge clk) begin
    q <= d;
end
endmodule