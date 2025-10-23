module freq_divbyfrac (
    input clk,
    input rst_n,
    output reg clk_div
);

// State machine states
typedef enum logic [1:0] {
    S0 = 2'b00,
    S1 = 2'b01,
    S2 = 2'b10,
    S3 = 2'b11
} state_t;

state_t current_state, next_state;
reg [1:0] counter;
reg phase_a, phase_b;
reg delayed_phase;

// State machine for phase control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S0;
        counter <= 2'b0;
    end else begin
        current_state <= next_state;
        counter <= counter + 1;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        S0: next_state = (counter == 2'd3) ? S1 : S0;
        S1: next_state = (counter == 2'd3) ? S2 : S1;
        S2: next_state = (counter == 2'd3) ? S3 : S2;
        S3: next_state = (counter == 2'd3) ? S0 : S3;
        default: next_state = S0;
    endcase
end

// Phase A generation (4 cycles high, 3 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        case (current_state)
            S0: phase_a <= 1'b1;
            S1: phase_a <= 1'b1;
            S2: if (counter == 2'd2) phase_a <= 1'b0;
            default: phase_a <= 1'b0;
        endcase
    end
end

// Phase B generation (3 cycles high, 4 low) with offset
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        case (current_state)
            S1: if (counter == 2'd1) phase_b <= 1'b1;
            S2: phase_b <= 1'b1;
            S3: if (counter == 2'd1) phase_b <= 1'b0;
            default: phase_b <= 1'b0;
        endcase
    end
end

// Delay phase_a by half cycle for edge alignment
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        delayed_phase <= 1'b0;
    end else begin
        delayed_phase <= phase_a;
    end
end

// Final output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= (phase_a | delayed_phase) ^ phase_b;
    end
end

endmodule