module TopModule(
    input  [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

always @(*) begin
    left = 0;
    down = 0;
    right = 0;
    up = 0;
    
    if (scancode[15:8] == 8'he0) begin
        case (scancode[7:0])
            8'he06b: left = 1;
            8'he072: down = 1;
            8'he074: right = 1;
            8'he075: up = 1;
            default: ;
        endcase
    end
end

endmodule