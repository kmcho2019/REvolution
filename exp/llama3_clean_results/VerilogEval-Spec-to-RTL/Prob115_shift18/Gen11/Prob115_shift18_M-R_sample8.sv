module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;
reg [63:0] next_q;

// Combinational logic to determine the next state
always @(*) begin
    case (amount)
        2'b00: next_q = {q_reg[62:0], 1'b0}; // Shift left by 1 bit
        2'b01: next_q = {q_reg[55:0], 8'd0}; // Shift left by 8 bits
        2'b10: next_q = {q_reg[63], q_reg[63:1]}; // Shift right by 1 bit (arithmetic)
        2'b11: next_q = {{8{q_reg[63]}}, q_reg[63:8]}; // Shift right by 8 bits (arithmetic)
        default: next_q = q_reg; // No shift
    endcase
end

// Sequential logic to update the state
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        q_reg <= next_q;
    end
end

// Output assignment
assign q = q_reg;

endmodule