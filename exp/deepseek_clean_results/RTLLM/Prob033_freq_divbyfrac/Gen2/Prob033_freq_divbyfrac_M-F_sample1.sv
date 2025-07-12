module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// State machine for 3.5x division (7 states)
reg [2:0] state;
reg [2:0] next_state;

// Phase control registers
reg phase_a;
reg phase_b;
reg phase_a_sync;
reg phase_b_sync;

// State definitions
localparam S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3;
localparam S4 = 3'd4, S5 = 3'd5, S6 = 3'd6;

// State transition logic (posedge)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S0;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        S0: next_state = S1;
        S1: next_state = S2;
        S2: next_state = S3;
        S3: next_state = S4;
        S4: next_state = S5;
        S5: next_state = S6;
        S6: next_state = S0;
        default: next_state = S0;
    endcase
end

// Phase A generation (4-clock period)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b1;  // Start high
    end else begin
        case (state)
            S0: phase_a <= 1'b1;
            S2: phase_a <= 1'b0;
            default: phase_a <= phase_a;
        endcase
    end
end

// Phase B generation (3-clock period with 180° offset)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;  // Start low
    end else begin
        case (state)
            S0: phase_b <= 1'b1;
            S1: phase_b <= 1'b1;
            S3: phase_b <= 1'b0;
            S4: phase_b <= 1'b0;
            default: phase_b <= phase_b;
        endcase
    end
end

// Synchronize phases to prevent glitches
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a_sync <= 1'b0;
        phase_b_sync <= 1'b0;
    end else begin
        phase_a_sync <= phase_a;
        phase_b_sync <= phase_b;
    end
end

// Combine phases with OR to create final output
assign clk_div = phase_a_sync | phase_b_sync;

endmodule