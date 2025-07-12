module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    case ({r, d})
        2'b10, 2'b11: q <= 1'b0; // Reset condition
        2'b01: q <= 1'b1; // Data input condition when d is 1 and r is 0
        2'b00: q <= 1'b0; // Data input condition when d is 0 and r is 0
        default: q <= 1'bx; // Default condition
    endcase
end

endmodule