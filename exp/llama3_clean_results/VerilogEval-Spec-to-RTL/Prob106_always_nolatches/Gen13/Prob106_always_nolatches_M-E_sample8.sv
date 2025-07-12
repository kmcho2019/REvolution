module TopModule(
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

reg [1:0] arrow_code;

always @(*) begin
    case (scancode)
        16'he06b: arrow_code = 2'b00; // left
        16'he072: arrow_code = 2'b01; // down
        16'he074: arrow_code = 2'b10; // right
        16'he075: arrow_code = 2'b11; // up
        default: arrow_code = 2'b00; // default to left (or any other safe state)
    endcase
end

assign left = (arrow_code == 2'b00);
assign down = (arrow_code == 2'b01);
assign right = (arrow_code == 2'b10);
assign up = (arrow_code == 2'b11);

endmodule