module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding
    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Simplified next state logic
    always @(*) begin
        if (state == A) begin
            if (w == 1'b0) next_state = B;
            else           next_state = A;
        end
        else if (state == B) begin
            if (w == 1'b0) next_state = C;
            else           next_state = D;
        end
        else if (state == C) begin
            if (w == 1'b0) next_state = E;
            else           next_state = D;
        end
        else if (state == D) begin
            if (w == 1'b0) next_state = F;
            else           next_state = A;
        end
        else if (state == E) begin
            if (w == 1'b0) next_state = E;
            else           next_state = D;
        end
        else if (state == F) begin
            if (w == 1'b0) next_state = C;
            else           next_state = D;
        end
        else
            next_state = A; // recover from invalid states
    end

    // Output asserted in E or F
    assign z = (state == E) || (state == F);

endmodule