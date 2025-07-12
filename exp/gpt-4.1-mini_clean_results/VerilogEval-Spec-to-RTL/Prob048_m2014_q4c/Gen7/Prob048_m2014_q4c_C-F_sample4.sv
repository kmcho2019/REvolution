module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    case (r)
        1'b1: q <= 1'b0;              // synchronous reset active high
        default: if (q != d)          // update q only if different to reduce switching
                    q <= d;
    endcase
end

endmodule