module counter_12(
    input logic rst_n,
    input logic clk,
    input logic valid_count,
    output logic [3:0] out
);

// Define states for the counter
enum logic [3:0] {S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11} state, next_state;

// Output logic to convert state to count value
always_comb begin
    case(state)
        S0: out = 4'b0000;
        S1: out = 4'b0001;
        S2: out = 4'b0010;
        S3: out = 4'b0011;
        S4: out = 4'b0100;
        S5: out = 4'b0101;
        S6: out = 4'b0110;
        S7: out = 4'b0111;
        S8: out = 4'b1000;
        S9: out = 4'b1001;
        S10: out = 4'b1010;
        S11: out = 4'b1011;
        default: out = 4'b0000; // Default to 0 if state is undefined
    endcase
end

// State transition logic
always_comb begin
    case(state)
        S0: next_state = valid_count ? S1 : S0;
        S1: next_state = valid_count ? S2 : S1;
        S2: next_state = valid_count ? S3 : S2;
        S3: next_state = valid_count ? S4 : S3;
        S4: next_state = valid_count ? S5 : S4;
        S5: next_state = valid_count ? S6 : S5;
        S6: next_state = valid_count ? S7 : S6;
        S7: next_state = valid_count ? S8 : S7;
        S8: next_state = valid_count ? S9 : S8;
        S9: next_state = valid_count ? S10 : S9;
        S10: next_state = valid_count ? S11 : S10;
        S11: next_state = valid_count ? S0 : S11; // Wrap around to S0
        default: next_state = S0; // Default to S0 if state is undefined
    endcase
end

// Sequential logic for state registration
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S0; // Reset to initial state
    end else begin
        state <= next_state; // Update state
    end
end

endmodule