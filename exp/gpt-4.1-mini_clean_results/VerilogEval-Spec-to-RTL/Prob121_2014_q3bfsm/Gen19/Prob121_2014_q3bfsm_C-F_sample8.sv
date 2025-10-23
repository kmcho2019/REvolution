module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // Gray code state encoding for low switching activity and clarity
    localparam [2:0]
        S0 = 3'b000, // 0
        S1 = 3'b001, // 1
        S2 = 3'b011, // 3
        S3 = 3'b010, // 2
        S4 = 3'b110; // 6

    reg [2:0] state, next_state;

    // Sequential logic: synchronous active-high reset and state update
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational logic: next state decoding with blocking assignments
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // Output logic: glitch-free continuous assignment from current state
    assign z = (state == S3) || (state == S4);

endmodule