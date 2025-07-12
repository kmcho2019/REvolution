module TopModule(
    input [15:0] scancode,
    output left,
    output down,
    output right,
    output up
);

reg left_reg, down_reg, right_reg, up_reg;

always @(*) begin
    case (scancode)
        16'he06b: begin left_reg = 1; down_reg = 0; right_reg = 0; up_reg = 0; end
        16'he072: begin left_reg = 0; down_reg = 1; right_reg = 0; up_reg = 0; end
        16'he074: begin left_reg = 0; down_reg = 0; right_reg = 1; up_reg = 0; end
        16'he075: begin left_reg = 0; down_reg = 0; right_reg = 0; up_reg = 1; end
        default: begin left_reg = 0; down_reg = 0; right_reg = 0; up_reg = 0; end
    endcase
end

assign left = left_reg;
assign down = down_reg;
assign right = right_reg;
assign up = up_reg;

endmodule