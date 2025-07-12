module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg; // Internal register for output q

always @ (posedge clk) begin
    q_reg <= d;
end

assign q = q_reg; // Continuously assign the value of q_reg to output q

endmodule