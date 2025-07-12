// Define a parameterizable DFF module to handle n-bit data
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    (* synthesis_attribute = "optimize_area" *)
    always_ff @(posedge clk) begin
        if (reset) q <= '0;
        else q <= d;
    end

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