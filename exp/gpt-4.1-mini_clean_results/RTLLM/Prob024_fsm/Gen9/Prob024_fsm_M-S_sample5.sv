module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    reg [2:0] state, next_state;

    // States represent how many bits matched:
    // 0: no match
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'

    always @(*) begin
        case(state)
            3'd0: next_state = (IN == 1'b1) ? 3'd1 : 3'd0;
            3'd1: next_state = (IN == 1'b0) ? 3'd2 : 3'd1;
            3'd2: next_state = (IN == 1'b0) ? 3'd3 : 3'd1;
            3'd3: next_state = (IN == 1'b1) ? 3'd4 : 3'd0;
            3'd4: begin
                if (IN == 1'b1)
                    next_state = 3'd1; // sequence matched, restart with '1'
                else
                    next_state = 3'd2; // maybe partial match starting with '0'
            end
            default: next_state = 3'd0;
        endcase
    end

    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule