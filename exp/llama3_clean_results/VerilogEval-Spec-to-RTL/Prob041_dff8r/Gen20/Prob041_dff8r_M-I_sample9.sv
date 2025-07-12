// Define a parameterizable DFF module to handle n-bit data
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    (* synthesis_attribute = "optimize_power" *)
    (* synthesis_attribute = "optimize_area" *)
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

    // Use a clock buffer cell to minimize clock skew
    logic clk_buf;
    (* synthesis_attribute = "optimize_clock_buffer" *)
    always_ff @(posedge clk) begin
        clk_buf <= clk;
    end

    DFF #(.WIDTH(8)) dff(
        .clk(clk_buf),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule