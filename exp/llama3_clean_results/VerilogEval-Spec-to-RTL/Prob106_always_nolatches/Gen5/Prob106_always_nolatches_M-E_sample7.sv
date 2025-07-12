module TopModule(
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

reg [3:0] one_hot;

always @(*) begin
    case (scancode)
        16'he06b: one_hot = 4'b0001;
        16'he072: one_hot = 4'b0010;
        16'he074: one_hot = 4'b0100;
        16'he075: one_hot = 4'b1000;
        default: one_hot = 4'b0000;
    endcase
end

assign left = one_hot[0];
assign down = one_hot[1];
assign right = one_hot[2];
assign up = one_hot[3];

endmodule