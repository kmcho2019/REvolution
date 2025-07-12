// DFF module: A single D flip-flop with initialization
module DFF(
    input clk,
    input d,
    output reg q
);

initial begin
    q = 0; // Initialize q to 0 at the start of the simulation
end

always @(posedge clk) begin
    q <= d;
end

endmodule

// TopModule: Instantiates 8 DFFs
module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFFs
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