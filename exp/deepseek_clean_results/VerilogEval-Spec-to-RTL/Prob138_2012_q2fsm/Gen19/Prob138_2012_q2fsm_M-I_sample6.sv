module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Optimized Gray code encoding with z=state[2]
    parameter [2:0] 
        A = 3'b000,
        B = 3'b001,
        C = 3'b011,
        D = 3'b010,
        E = 3'b110,
        F = 3'b100;

    reg [2:0] current_state, next_state;
    reg clock_enable;

    // State transition logic with optimized critical path
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C, F: next_state = w ? (current_state == C ? E : C) : D;  // Shared transition
            D: begin
                if (w) next_state = F;
                else next_state = A;  // Simplified for better timing
            end
            E: next_state = w ? E : D;
            default: next_state = A;
        endcase

        // Clock gating control for power savings
        clock_enable = !(current_state == E && w);
    end

    // State storage with compact reset and clock gating
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else if (clock_enable) begin
            current_state <= next_state;
        end
    end

    // Output logic - registered for better timing
    always @(posedge clk) begin
        if (reset) begin
            z <= 1'b0;
        end else begin
            z <= current_state[2];
        end
    end

endmodule