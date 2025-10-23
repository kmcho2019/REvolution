// Define a parameterizable DFF module to handle n-bit data
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    // Use a generate block to instantiate the DFFs
    generate
        for (genvar i = 0; i < WIDTH; i++) begin
            always_ff @(posedge clk) begin
                if (reset) begin
                    q[i] <= 1'b0;
                end else begin
                    q[i] <= d[i];
                end
            end
        end
    endgenerate

endmodule

// Instantiate the DFF module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Adding a clock buffer to minimize clock skew
logic clk_buf;
buf clk_buf(clk, clk_buf);

DFF #(.WIDTH(8)) dff(
   .clk(clk_buf), // Using the buffered clock
   .reset(reset),
   .d(d),
   .q(q)
);

endmodule