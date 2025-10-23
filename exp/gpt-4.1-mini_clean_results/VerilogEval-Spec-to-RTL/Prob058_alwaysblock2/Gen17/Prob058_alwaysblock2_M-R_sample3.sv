module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

// Continuous assignment with direct XOR operator
assign out_assign = a ^ b;

// Combinational always block using a case statement to implement XOR
always @(*) begin
    case ({a,b})
        2'b00, 2'b11: out_always_comb = 1'b0;
        2'b01, 2'b10: out_always_comb = 1'b1;
        default:      out_always_comb = 1'bx; // Defensive coding, though unreachable
    endcase
end

// Sequential logic with two pipeline stages for XOR result
reg stage1;
always @(posedge clk) begin
    stage1 <= a ^ b;
    out_always_ff <= stage1;
end

endmodule