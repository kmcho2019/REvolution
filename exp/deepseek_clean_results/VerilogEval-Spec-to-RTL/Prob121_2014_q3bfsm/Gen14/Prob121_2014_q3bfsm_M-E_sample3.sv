module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // Gray-coded states
    parameter [2:0] S0 = 3'b000,  // 000
                    S1 = 3'b001,  // 001
                    S2 = 3'b011,  // 010 -> 011 (Gray)
                    S3 = 3'b010,  // 011 -> 010 (Gray)
                    S4 = 3'b110;  // 100 -> 110 (Gray)

    reg [2:0] current_state, next_state;

    // Combinational next-state logic
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

    // Sequential state and output update
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            z <= 1'b0;
        end
        else begin
            current_state <= next_state;
            // Output depends on next state (Mealy-Moore hybrid)
            z <= (next_state == S3) || (next_state == S4);
        end
    end

endmodule