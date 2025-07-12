module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

wire [63:0] shift_result;

// Conditional shift computation
assign shift_result = (ena) ? 
    (load ? data : 
        (case (amount)
            2'b00: {q[62:0], 1'b0};               // Left 1
            2'b01: {q[55:0], 8'b0};               // Left 8
            2'b10: {q[63], q[63:1]};              // Right 1 (arithmetic)
            2'b11: {{8{q[63]}}, q[63:8]};         // Right 8 (arithmetic)
            default: q;
        endcase)
    ) : q;

always @(posedge clk) begin
    q <= shift_result;
end

endmodule