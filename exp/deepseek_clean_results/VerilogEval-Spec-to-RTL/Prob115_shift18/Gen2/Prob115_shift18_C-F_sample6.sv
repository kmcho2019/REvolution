module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

wire [63:0] next_q;

assign next_q = load ? data : 
                ena ? 
                case (amount)
                    2'b00: {q[62:0], 1'b0},         // Shift left by 1
                    2'b01: {q[55:0], 8'b0},         // Shift left by 8
                    2'b10: {q[63], q[63:1]},        // Arithmetic right shift by 1
                    2'b11: {{8{q[63]}}, q[63:8]}    // Arithmetic right shift by 8
                endcase : q;

always @(posedge clk) begin
    q <= next_q;
end

endmodule