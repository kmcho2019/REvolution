module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    case ({ar, clk})
        2'b10: q <= d;
        2'b01: q <= d;
        2'b11: q <= d;
        default: q <= 1'b0;
    endcase
end

endmodule