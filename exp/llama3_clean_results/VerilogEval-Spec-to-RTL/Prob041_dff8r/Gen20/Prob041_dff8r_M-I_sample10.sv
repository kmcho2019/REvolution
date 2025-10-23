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
    logic [WIDTH-1:0] q_int;
    always_ff @(posedge clk or posedge reset) begin
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

    // Use a clock buffer to optimize the clock distribution network
    logic clk_buf;
    (* synthesis_attribute = "clock_buffer" *)
    bufif1 clk_buf(clk, 1'b1);

    DFF #(.WIDTH(8)) dff(
        .clk(clk_buf),
        .reset(reset),
        .d(d),
        .q(q)
    );

endmodule