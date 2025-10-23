module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Single register for all 8 bits
reg [7:0] q_reg;

// Single always block for all flip-flops
always @(posedge clk) begin
    q_reg <= d;
end

// Direct assignment of register to output
assign q = q_reg;

endmodule