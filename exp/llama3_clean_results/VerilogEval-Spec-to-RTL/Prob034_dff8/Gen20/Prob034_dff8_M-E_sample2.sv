// Novel TopModule using a shift register and 8 D flip-flops
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Intermediate shift register to capture input d
reg [7:0] shift_reg;

// Capture input d into shift register at every positive clock edge
always @(posedge clk) begin
    shift_reg <= d;
end

// Generate 8 DFFs and connect them in parallel to output q
always @(posedge clk) begin
    q <= shift_reg;
end

endmodule