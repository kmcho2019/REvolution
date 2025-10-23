module TopModule(
    input         clk,
    input         areset,
    input         load,
    input         ena,
    input  [3:0]   data,
    output [3:0]   q
);

reg [3:0] q_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0; // Reset to zero
    end else if (load) begin
        q_reg <= data; // Load with new data
    end else if (ena) begin
        q_reg <= {1'b0, q_reg[3:1]}; // Shift right, q[3] becomes zero
    end
end

assign q = q_reg;

endmodule