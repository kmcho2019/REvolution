module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    reg [2:0] state, next_state;

    // State update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 3'd0; // A
        else
            state <= next_state;
    end

    // Next-state logic using case statement
    always @(*) begin
        case (state)
            3'd0: next_state = w ? 3'd1 : 3'd0; // A
            3'd1: next_state = w ? 3'd2 : 3'd3; // B
            3'd2: next_state = w ? 3'd4 : 3'd3; // C
            3'd3: next_state = w ? 3'd5 : 3'd0; // D
            3'd4: next_state = w ? 3'd4 : 3'd3; // E
            3'd5: next_state = w ? 3'd2 : 3'd3; // F
            default: next_state = 3'd0;
        endcase
    end

    // Output z is 1 in states E(4) and F(5)
    assign z = (state == 3'd4) || (state == 3'd5);

endmodule