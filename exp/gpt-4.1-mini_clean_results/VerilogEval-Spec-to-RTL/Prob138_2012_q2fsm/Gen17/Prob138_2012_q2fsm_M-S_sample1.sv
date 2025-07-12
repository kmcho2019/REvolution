module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    reg [2:0] state, next_state;

    // State encoding: A=0, B=1, C=2, D=3, E=4, F=5
    always @(posedge clk) begin
        if (reset)
            state <= 3'd0; // A
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            3'd0: next_state = w ? 3'd1 : 3'd0; // A
            3'd1: next_state = w ? 3'd2 : 3'd3; // B
            3'd2: next_state = w ? 3'd4 : 3'd3; // C
            3'd3: next_state = w ? 3'd5 : 3'd0; // D
            3'd4: next_state = w ? 3'd4 : 3'd3; // E
            3'd5: next_state = w ? 3'd2 : 3'd3; // F
            default: next_state = 3'd0;         // default to A
        endcase
    end

    assign z = (state == 3'd4) || (state == 3'd5);

endmodule