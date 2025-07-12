module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Gray-coded state definitions for optimal transitions
    reg [2:0] state, next_state;
    
    // Gray encoding: 000->001->011->010->110 (equivalent to binary 000,001,011,010,100)
    // This minimizes bit transitions between consecutive states
    localparam [2:0] S0 = 3'b000,
                     S1 = 3'b001,
                     S3 = 3'b011,
                     S2 = 3'b010,
                     S4 = 3'b100;

    // Combinational next state logic
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

    // Sequential state update with clock gating opportunity
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else if (state != next_state) // Potential clock gating point
            state <= next_state;
    end

    // Output logic - simple combinational
    assign z = (state == S3) || (state == S4);

endmodule