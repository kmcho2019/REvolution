// Define a parameterizable DFF module to handle n-bit data
module DFF #(
    parameter WIDTH = 8
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

// Instantiate the DFF module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Using a generate block for flexibility and potential future expansion
generate
    for (genvar i = 0; i < 8; i++) begin
        DFF #(.WIDTH(1)) dff(
           .clk(clk),
           .reset(reset),
           .d(d[i]),
           .q(q[i])
        );
    end
endgenerate

endmodule