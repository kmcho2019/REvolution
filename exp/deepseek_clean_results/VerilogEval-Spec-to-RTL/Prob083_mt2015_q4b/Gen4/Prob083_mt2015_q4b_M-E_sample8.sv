module TopModule (
    input x,
    input y,
    output reg z
);

    reg state;

    localparam IDLE = 1'b0;
    localparam MATCH = 1'b1;

    always @(*) begin
        case (state)
            IDLE: z = 1'b0;
            MATCH: z = 1'b1;
        endcase
    end

    always @(*) begin
        if ((x == 0 && y == 0) || (x == 1 && y == 1))
            state = MATCH;
        else
            state = IDLE;
    end

endmodule