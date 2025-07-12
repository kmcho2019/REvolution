module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

// Define an enumeration for the states with sufficient bit width
enum logic [2:0] {
    S0 = 3'b000,
    S1 = 3'b001,
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100
} state, next_state;

// Next state logic
always_comb begin
    case (state)
        S0: begin
            next_state = data ? S1 : S0;
        end
        S1: begin
            next_state = data ? S2 : S0;
        end
        S2: begin
            next_state = data ? S2 : S3;
        end
        S3: begin
            next_state = data ? S4 : S0;
        end
        S4: begin
            next_state = S4; // Stay in S4 once reached
        end
        default: next_state = S0;
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= S0;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (state == S4) begin
            start_shifting <= 1; // Set start_shifting to 1 when in state S4
        end else begin
            start_shifting <= 0; // Reset start_shifting when not in S4
        end
    end
end

endmodule