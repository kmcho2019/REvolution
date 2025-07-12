module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

wire [63:0] next_q;

always @(*) begin
    case ({load, ena, amount})
        {1'b1, 1'bx, 2'bxx}: next_q = data;  // Load has highest priority
        {1'b0, 1'b1, 2'b00}: next_q = q << 1;  // Left shift by 1
        {1'b0, 1'b1, 2'b01}: next_q = q << 8;  // Left shift by 8
        {1'b0, 1'b1, 2'b10}: next_q = {q[63], q[63:1]};  // Right shift by 1 (arithmetic)
        {1'b0, 1'b1, 2'b11}: next_q = {{8{q[63]}}, q[63:8]};  // Right shift by 8 (arithmetic)
        default: next_q = q;  // No operation
    endcase
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule