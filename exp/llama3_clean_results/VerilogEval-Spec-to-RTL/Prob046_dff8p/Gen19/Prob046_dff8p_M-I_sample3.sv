// Define a parameterizable D flip-flop module with active high synchronous reset
module DFF #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        // For an 8-bit register, reset to 0x34; for other sizes, reset to a pattern
        // that can be defined based on the parameter WIDTH
        q_reg <= (WIDTH == 8) ? 8'h34 : {WIDTH{1'b0}}; // Default to zero for other widths
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg; // assign output directly from register

endmodule

// TopModule instantiates a DFF with the desired width
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

DFF #(.WIDTH(8)) u_dff(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule