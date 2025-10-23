module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    case (r)
        1'b1: q <= 1'b0;   // synchronous reset active
        1'b0: q <= d;      // normal operation
    endcase
end

endmodule