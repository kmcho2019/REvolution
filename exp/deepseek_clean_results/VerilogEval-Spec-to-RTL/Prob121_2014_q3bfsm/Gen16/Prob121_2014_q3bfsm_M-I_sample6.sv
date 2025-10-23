module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Gray-coded states to reduce switching power
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b011;
    parameter S3 = 3'b010;
    parameter S4 = 3'b110;

    reg [2:0] current_state, next_state;

    // State transition logic using case for better timing
    always @(*) begin
        case (current_state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Output logic - simplified using state bits
    // z is high in states S3 (010) and S4 (110) - checking bit[1] and bit[2]
    assign z = current_state[1] | current_state[2];

endmodule