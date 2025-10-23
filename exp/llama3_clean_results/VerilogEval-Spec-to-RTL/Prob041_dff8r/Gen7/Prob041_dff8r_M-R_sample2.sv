// Define a parameterizable DFF module to handle 8-bit data
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

logic [WIDTH-1:0] q_next;

// Combinational logic for next state
assign q_next = reset ? {WIDTH{1'b0}} : d;

// Sequential logic with synchronous reset
always_ff @(posedge clk) begin
    q <= q_next;
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