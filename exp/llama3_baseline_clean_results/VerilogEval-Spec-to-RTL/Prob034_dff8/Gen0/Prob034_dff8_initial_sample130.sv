module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Instantiate 8 DFFs
reg [7:0] q_reg;

always @(posedge clk) begin
    q_reg <= d;
end

// Assign output
assign q = q_reg;

endmodule