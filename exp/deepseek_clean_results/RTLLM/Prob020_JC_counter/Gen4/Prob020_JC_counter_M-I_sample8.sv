module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Clock gating control signals
wire terminal_state = &Q || ~|Q;  // All 1s or all 0s
reg gated_clk;

// Two-stage pipeline registers
reg [63:0] Q_next;
reg [63:0] Q_shifted;

always @(*) begin
    // Stage 1: Shift operation
    Q_shifted = {Q[0] ? 1'b0 : 1'b1, Q[63:1]};
    
    // Stage 2: Next state logic
    Q_next = terminal_state ? Q : Q_shifted;
end

// Clock gating logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        gated_clk <= 1'b0;
    end else begin
        gated_clk <= ~terminal_state;
    end
end

// Main counter logic with gated clock
always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= Q_next;
    end
end

endmodule