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

always @(*) begin
    if (load) begin
        next_q = data;
    end else if (ena) begin
        case (amount)
            2'b00: next_q = {q_reg[62:0], 1'b0}; // Left shift by 1
            2'b01: next_q = {q_reg[55:0], 8'd0}; // Left shift by 8
            2'b10: next_q = {q_reg[63], q_reg[63:1]}; // Arithmetic right shift by 1
            2'b11: next_q = {{8{q_reg[63]}}, q_reg[63:8]}; // Arithmetic right shift by 8
            default: next_q = q_reg;
        endcase
    end else begin
        next_q = q_reg;
    end
end

always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule