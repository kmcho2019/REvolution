module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// State definitions for 3.5x division (7 states total)
localparam S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3;
localparam S4 = 3'd4, S5 = 3'd5, S6 = 3'd6;

// State registers
reg [2:0] current_state, next_state;
reg clk_0, clk_180;
wire clk_div_comb;

// State transition logic (combinational)
always @(*) begin
    case (current_state)
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

// State register (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Base clock generation (0° phase)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_0 <= 1'b0;
    end else begin
        clk_0 <= (current_state < S4); // High for states 0-3 (4 cycles)
    end
end

// Phase-shifted clock generation (180° phase)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_180 <= 1'b0;
    end else begin
        // Phase shift by 3.5 cycles (half period)
        case (current_state)
            S3: clk_180 <= 1'b1;
            S4: clk_180 <= 1'b1;
            S5: clk_180 <= 1'b1;
            S6: clk_180 <= 1'b1;
            S0: clk_180 <= 1'b1;
            default: clk_180 <= 1'b0;
        endcase
    end
end

// Combine phases
assign clk_div_comb = clk_0 | clk_180;

// Synchronized output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div_comb;
    end
end

endmodule