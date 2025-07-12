module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

// Using 8 D flip-flops triggered by the positive edge of the clock
reg [7:0] q_reg;

always @ (posedge clk) begin
    q_reg <= d;
end

assign q = q_reg;

endmodule