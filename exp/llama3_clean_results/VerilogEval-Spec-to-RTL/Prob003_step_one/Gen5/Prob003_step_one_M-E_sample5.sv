module TopModule #(
    parameter OUTPUT_WIDTH = 1
) (
    output [OUTPUT_WIDTH-1:0] one
);

always @(*) begin
    case (OUTPUT_WIDTH)
        1: one = 1'b1;
        default: one = {OUTPUT_WIDTH{1'b1}};
    endcase
end

endmodule