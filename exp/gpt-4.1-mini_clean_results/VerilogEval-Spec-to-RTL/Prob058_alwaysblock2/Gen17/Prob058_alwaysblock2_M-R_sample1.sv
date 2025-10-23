module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

// out_assign directly assigned as XOR of inputs
assign out_assign = a ^ b;

// out_always_comb computed in combinational always block using concatenation
always @(*) begin
    case ({a, b})
        2'b00: out_always_comb = 1'b0;
        2'b01: out_always_comb = 1'b1;
        2'b10: out_always_comb = 1'b1;
        2'b11: out_always_comb = 1'b0;
        default: out_always_comb = 1'b0;
    endcase
end

// out_always_ff registered version of out_always_comb on posedge clk
always @(posedge clk) begin
    out_always_ff <= out_always_comb;
end

endmodule