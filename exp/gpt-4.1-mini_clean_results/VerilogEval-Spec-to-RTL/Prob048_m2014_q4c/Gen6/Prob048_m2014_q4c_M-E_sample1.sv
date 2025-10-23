module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    case (r)
        1'b1: q <= 1'b0;   // synchronous reset active high
        default: q <= d;   // capture input d when reset is inactive
    endcase
end

endmodule