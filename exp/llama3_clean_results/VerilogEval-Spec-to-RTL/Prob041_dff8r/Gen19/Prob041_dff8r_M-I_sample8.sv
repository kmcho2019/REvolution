// Define a parameterizable D flip-flop module with clock enable
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input enable,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

logic [WIDTH-1:0] reg;

always_ff @(posedge clk) begin
    if (reset) begin
        reg <= {WIDTH{1'b0}};
    end else if (enable) begin
        reg <= d;
    end
end

assign q = reg;

endmodule

// Instantiate the D flip-flop module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic enable;

// Generate the clock enable signal
assign enable = 1'b1; // Always enable the clock

DFF #(.WIDTH(8)) dff(
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .d(d),
    .q(q)
);

endmodule