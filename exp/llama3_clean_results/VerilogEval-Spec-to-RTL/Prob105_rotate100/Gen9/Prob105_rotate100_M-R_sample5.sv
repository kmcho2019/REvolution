module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Load logic
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q_next;
    end
end

// Rotation logic
wire [99:0] q_next;
assign q_next = ena[1] ? {q_reg[98:0], q_reg[99]} : (ena[0] ? {q_reg[0], q_reg[99:1]} : q_reg);

assign q = q_reg;

endmodule