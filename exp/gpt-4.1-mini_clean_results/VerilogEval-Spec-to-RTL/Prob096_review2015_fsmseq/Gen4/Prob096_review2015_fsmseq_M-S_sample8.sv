module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

    // State encoding (binary)
    // 0: no match
    // 1: matched '1'
    // 2: matched "11"
    // 3: matched "110"
    // 4: matched "1101" (final)
    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= 3'd0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            3'd0: next_state = data ? 3'd1 : 3'd0;
            3'd1: next_state = data ? 3'd2 : 3'd0;
            3'd2: next_state = data ? 3'd2 : 3'd3;
            3'd3: next_state = data ? 3'd4 : 3'd0;
            3'd4: next_state = 3'd4; // stay in final detected state
            default: next_state = 3'd0;
        endcase
    end

    assign start_shifting = (state == 3'd4);

endmodule