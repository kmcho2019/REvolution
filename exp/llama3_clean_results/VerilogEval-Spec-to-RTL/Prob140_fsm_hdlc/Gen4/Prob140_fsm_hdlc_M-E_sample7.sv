module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

// Define the states
enum logic [2:0] {
    S0,  // Initial state
    S1,  // One '1' received
    S2,  // Two '1's received
    S3,  // Three '1's received
    S4,  // Four '1's received
    S5,  // Five '1's received
    S6   // Six '1's received
} state, next_state;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= S0;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            S5: begin
                if (in) begin
                    flag <= 1'b1;
                end else begin
                    disc <= 1'b1;
                end
            end
            S6: begin
                if (in) begin
                    err <= 1'b1;
                end else begin
                    flag <= 1'b1;
                end
            end
            default: begin
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
        endcase
    end
end

// Next state logic
always_comb begin
    case (state)
        S0: begin
            if (in) begin
                next_state = S1;
            end else begin
                next_state = S0;
            end
        end
        S1: begin
            if (in) begin
                next_state = S2;
            end else begin
                next_state = S0;
            end
        end
        S2: begin
            if (in) begin
                next_state = S3;
            end else begin
                next_state = S0;
            end
        end
        S3: begin
            if (in) begin
                next_state = S4;
            end else begin
                next_state = S0;
            end
        end
        S4: begin
            if (in) begin
                next_state = S5;
            end else begin
                next_state = S0;
            end
        end
        S5: begin
            if (in) begin
                next_state = S6;
            end else begin
                next_state = S0;
            end
        end
        S6: begin
            if (in) begin
                next_state = S6;
            end else begin
                next_state = S0;
            end
        end
        default: next_state = S0;
    endcase
end

endmodule