module TopModule(
    input  [15:0] scancode,
    output reg [1:0] arrow_key
);

always @(*) begin
    case (scancode)
        16'he06b: arrow_key = 2'b01; // left
        16'he072: arrow_key = 2'b10; // down
        16'he074: arrow_key = 2'b11; // right
        16'he075: arrow_key = 2'b00; // up
        default: arrow_key = 2'b00; // none
    endcase
end

assign left   = arrow_key == 2'b01;
assign down   = arrow_key == 2'b10;
assign right  = arrow_key == 2'b11;
assign up     = arrow_key == 2'b00;

endmodule