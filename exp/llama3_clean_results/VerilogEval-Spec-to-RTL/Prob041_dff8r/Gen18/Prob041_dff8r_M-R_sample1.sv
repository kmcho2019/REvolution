module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);
    // Using a generate block to instantiate the DFF module eight times
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            // Instantiate the DFF module
            DFF #(.WIDTH(1)) dff(
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule

// Define a parameterizable DFF module to handle 1-bit data
module DFF #(
    parameter WIDTH = 1
)(
    input clk,
    input reset,
    input d,
    output logic q
);
    // Using always_ff block with non-blocking assignment for synchronous reset DFF
    always_ff @(posedge clk) begin
        if (reset) q <= 1'b0;
        else q <= d;
    end
endmodule