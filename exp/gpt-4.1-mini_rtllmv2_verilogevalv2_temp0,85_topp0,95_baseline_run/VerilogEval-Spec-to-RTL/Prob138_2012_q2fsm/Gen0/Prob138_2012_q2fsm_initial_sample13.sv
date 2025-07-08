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

    // State flip-flops (sequential logic)
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // Output logic (Moore output)
    assign z = (state == E) ? 1'b1 : 1'b0;

endmodule