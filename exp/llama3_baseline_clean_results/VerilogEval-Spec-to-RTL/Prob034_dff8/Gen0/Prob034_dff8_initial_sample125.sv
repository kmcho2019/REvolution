module TopModule(
    input           clk,    // clock signal
    input  [7:0]     d,     // 8-bit input data
    output [7:0]     q      // 8-bit output data
);

// Instantiate 8 D flip-flops
reg [7:0] q_reg;

always @(posedge clk) begin
    q_reg <= d;
end

assign q = q_reg;

endmodule