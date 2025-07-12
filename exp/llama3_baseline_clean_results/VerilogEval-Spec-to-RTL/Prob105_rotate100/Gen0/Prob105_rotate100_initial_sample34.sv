module TopModule (
    input  clk,
    input  load,
    input  [1:0] ena,
    input  [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena == 2'b01) begin
        // Rotate right by one bit
        q_reg <= {q_reg[0], q_reg[99:1]};
    end else if (ena == 2'b10) begin
        // Rotate left by one bit
        q_reg <= {q_reg[98:0], q_reg[99]};
    end else begin
        // No rotation
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule