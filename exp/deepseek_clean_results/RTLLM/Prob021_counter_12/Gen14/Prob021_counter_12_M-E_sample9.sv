module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

// State encoding - each state directly represents count value
parameter [3:0] S0 = 4'b0000,
                S1 = 4'b0001,
                S2 = 4'b0010,
                S3 = 4'b0011,
                S4 = 4'b0100,
                S5 = 4'b0101,
                S6 = 4'b0110,
                S7 = 4'b0111,
                S8 = 4'b1000,
                S9 = 4'b1001,
                S10 = 4'b1010,
                S11 = 4'b1011;

reg [3:0] current_state, next_state;

// State transition logic
always @(*) begin
    if (!rst_n) begin
        next_state = S0;
    end
    else if (valid_count) begin
        case (current_state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S4;
            S4: next_state = S5;
            S5: next_state = S6;
            S6: next_state = S7;
            S7: next_state = S8;
            S8: next_state = S9;
            S9: next_state = S10;
            S10: next_state = S11;
            S11: next_state = S0;
            default: next_state = S0;
        endcase
    end
    else begin
        next_state = current_state;
    end
end

// State register update
always @(posedge clk) begin
    current_state <= next_state;
end

// Output assignment
always @(*) begin
    out = current_state;
end

endmodule