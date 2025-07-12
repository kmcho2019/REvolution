// Define a parameterizable DFF module to handle n-bit data
module DFF #(
    parameter WIDTH = 1
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= {WIDTH{1'b0}};
    end else begin
        q <= d;
    end
end

endmodule

// Instantiate the DFF module within the TopModule using a generate block
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i++) begin: dff_gen
        DFF #(.WIDTH(1)) dff(
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule