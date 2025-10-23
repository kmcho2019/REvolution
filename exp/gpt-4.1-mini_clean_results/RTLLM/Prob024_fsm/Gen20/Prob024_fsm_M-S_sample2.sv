module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            3'd0: next_state = IN ? 3'd1 : 3'd0;
            3'd1: next_state = IN ? 3'd1 : 3'd2;
            3'd2: next_state = IN ? 3'd1 : 3'd3;
            3'd3: next_state = IN ? 3'd4 : 3'd0;
            3'd4: next_state = IN ? 3'd1 : 3'd2;
            default: next_state = 3'd0;
        endcase
    end

    always @(posedge CLK or posedge RST) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    assign MATCH = (state == 3'd4) && IN;

endmodule