module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;

// Coarse-grained stage: byte-level shifter
wire [63:0] byte_shifted_q;
assign byte_shifted_q = (amount == 2'b01)? {q_reg[55:0], 8'd0} :
                         (amount == 2'b11)? {{8{q_reg[63]}}, q_reg[63:8]} :
                         q_reg;

// Fine-grained stage: bit-level shifter
wire [63:0] bit_shifted_q;
assign bit_shifted_q = (amount == 2'b00)? {q_reg[62:0], 1'b0} :
                         (amount == 2'b10)? {q_reg[63], q_reg[63:1]} :
                         byte_shifted_q;

// Sequential logic
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        q_reg <= bit_shifted_q;
    end
end

assign q = q_reg;

endmodule