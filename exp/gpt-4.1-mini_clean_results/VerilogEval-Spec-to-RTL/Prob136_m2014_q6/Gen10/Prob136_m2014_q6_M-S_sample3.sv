module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

    reg [2:0] state, next_state;

    // State encoding (for reference)
    // A = 3'd0, B = 3'd1, C = 3'd2, D = 3'd3, E = 3'd4, F = 3'd5

    // State register update
    always @(posedge clk) begin
        if (reset)
            state <= 3'd0; // A
        else
            state <= next_state;
    end

    // Next state logic using if-else chains
    always @(*) begin
        if (state == 3'd0)       // A
            next_state = (w == 1'b0) ? 3'd1 : 3'd0;
        else if (state == 3'd1)  // B
            next_state = (w == 1'b0) ? 3'd2 : 3'd3;
        else if (state == 3'd2)  // C
            next_state = (w == 1'b0) ? 3'd4 : 3'd3;
        else if (state == 3'd3)  // D
            next_state = (w == 1'b0) ? 3'd5 : 3'd0;
        else if (state == 3'd4)  // E
            next_state = (w == 1'b0) ? 3'd4 : 3'd3;
        else if (state == 3'd5)  // F
            next_state = (w == 1'b0) ? 3'd2 : 3'd3;
        else
            next_state = 3'd0; // default to A
    end

    // Output logic: z=1 when state == E or F
    assign z = (state == 3'd4) || (state == 3'd5);

endmodule