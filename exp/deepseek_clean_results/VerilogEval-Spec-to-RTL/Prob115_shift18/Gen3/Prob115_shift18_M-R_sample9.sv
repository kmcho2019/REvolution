module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

wire [63:0] shift_result;
wire [63:0] next_q;

// Decode shift amount and direction
assign shift_result = 
    (amount == 2'b00) ? {q[62:0], 1'b0} :  // Left shift 1
    (amount == 2'b01) ? {q[55:0], 8'b0} :  // Left shift 8
    (amount == 2'b10) ? {q[63], q[63:1]} : // Right shift 1 (arithmetic)
    {{8{q[63]}}, q[63:8]};                 // Right shift 8 (arithmetic)

assign next_q = load ? data : (ena ? shift_result : q);

always @(posedge clk) begin
    q <= next_q;
end

endmodule