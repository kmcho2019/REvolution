module TopModule (
    input x,
    input y,
    output reg z
);
    reg [1:0] state;

    always @(*) begin
        case ({x,y})
            2'b00: z = 1'b1;
            2'b11: z = 1'b1;
            2'b01: z = (state == 2'b11) ? 1'b1 : 1'b0;
            2'b10: z = (state == 2'b00) ? 1'b1 : 1'b0;
        endcase
    end

    always @(*) begin
        state = {x,y};
    end
endmodule