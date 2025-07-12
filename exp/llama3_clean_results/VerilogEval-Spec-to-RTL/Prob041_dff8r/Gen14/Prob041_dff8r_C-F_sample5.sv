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
    logic [WIDTH-1:0] q_int;
    always_ff @(posedge clk) begin
        if (reset) begin
            q_int <= '0;
        end else begin
            q_int <= d;
        end
    end
    assign q = q_int;

endmodule

// Instantiate the DFF module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

DFF #(.WIDTH(8)) dff(
   .clk(clk),
   .reset(reset),
   .d(d),
   .q(q)
);

endmodule