module TopModule(
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

reg [15:0] scancode_map[4] = '{16'he06b, 16'he072, 16'he074, 16'he075};
reg [3:0] output_map[4] = '{4'b0001, 4'b0010, 4'b0100, 4'b1000};

always @(*) begin
    left = 1'b0;
    down = 1'b0;
    right = 1'b0;
    up = 1'b0;

    for (int i = 0; i < 4; i++) begin
        if (scancode == scancode_map[i]) begin
            case (i)
                0: left = 1'b1;
                1: down = 1'b1;
                2: right = 1'b1;
                3: up = 1'b1;
            endcase
        end
    end
end

endmodule