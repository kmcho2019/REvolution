module TopModule (
    input x,
    input y,
    output reg z
);
    reg [1:0] state;

    always @(*) begin
        case(state)
            2'b00: z = 1;
            2'b01: z = 0;
            2'b10: z = 0;
            2'b11: z = 1;
            default: z = 1;
        endcase
    end

    always @(*) begin
        state <= {x, y};
    end
endmodule