module TopModule (
    input x,
    input y,
    output reg z
);

    reg [1:0] state;
    localparam IDLE = 2'b00;
    localparam FIRST_MATCH = 2'b01;
    localparam SECOND_MATCH = 2'b10;

    always @* begin
        case (state)
            IDLE: 
                z = (x == y) ? 1'b0 : 1'b0;
            FIRST_MATCH: 
                z = (x == y) ? 1'b1 : 1'b0;
            SECOND_MATCH: 
                z = (x == y) ? 1'b1 : 1'b0;
            default: 
                z = 1'b0;
        endcase
    end

    always @* begin
        case (state)
            IDLE: 
                state = (x == y) ? FIRST_MATCH : IDLE;
            FIRST_MATCH: 
                state = (x == y) ? SECOND_MATCH : 
                       (x != y) ? IDLE : FIRST_MATCH;
            SECOND_MATCH: 
                state = (x == y) ? SECOND_MATCH : IDLE;
            default: 
                state = IDLE;
        endcase
    end
endmodule