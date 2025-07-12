module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] shift_reg;

// Next state logic
wire [63:0] next_shift = load ? data : 
                       (ena ? (amount[1] ? 
                              (amount[0] ? { {8{shift_reg[63]}}, shift_reg[63:8] } :  // Right by 8
                                           { shift_reg[63], shift_reg[63:1] }) :      // Right by 1
                              (amount[0] ? shift_reg << 8 :                           // Left by 8
                                           shift_reg << 1)) :                         // Left by 1
                       shift_reg;

// Clock-gated register update
assign q = shift_reg;
always @(posedge clk) begin
    shift_reg <= next_shift;
end

endmodule