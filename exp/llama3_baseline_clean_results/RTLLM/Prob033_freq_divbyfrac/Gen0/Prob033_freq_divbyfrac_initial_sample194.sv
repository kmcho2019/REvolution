module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
localparam MUL2_DIV_CLK = 7; // Total clock cycles for division
localparam PHASE1_CLK = 4;   // Clock cycles for first phase
localparam PHASE2_CLK = 3;   // Clock cycles for second phase

// State machine states
enum logic [1:0] {IDLE, PHASE1, PHASE2} state, next_state;

// Counter for clock cycles
reg [2:0] cnt;

// Signals for divided clock phases
reg clk_phase1;
reg clk_phase2;
reg clk_phase1_delayed;
reg clk_phase2_advanced;

// State machine and counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        cnt <= 3'b0;
        clk_phase1 <= 1'b0;
        clk_phase2 <= 1'b0;
        clk_phase1_delayed <= 1'b0;
        clk_phase2_advanced <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (cnt == MUL2_DIV_CLK - 1) begin
                    state <= PHASE1;
                    cnt <= 3'b0;
                end else begin
                    state <= IDLE;
                    cnt <= cnt + 1;
                end
            end
            PHASE1: begin
                if (cnt == PHASE1 - 1) begin
                    state <= PHASE2;
                    cnt <= 3'b0;
                end else begin
                    state <= PHASE1;
                    cnt <= cnt + 1;
                end
            end
            PHASE2: begin
                if (cnt == PHASE2 - 1) begin
                    state <= IDLE;
                    cnt <= 3'b0;
                end else begin
                    state <= PHASE2;
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

// Clock phase generation logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_phase1 <= 1'b0;
        clk_phase2 <= 1'b0;
        clk_phase1_delayed <= 1'b0;
        clk_phase2_advanced <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (cnt == MUL2_DIV_CLK - 1) begin
                    clk_phase1 <= 1'b1;
                    clk_phase2 <= 1'b0;
                end else begin
                    clk_phase1 <= 1'b0;
                    clk_phase2 <= 1'b0;
                end
            end
            PHASE1: begin
                if (cnt == PHASE1 - 1) begin
                    clk_phase1 <= 1'b0;
                    clk_phase2 <= 1'b1;
                end else begin
                    clk_phase1 <= 1'b1;
                    clk_phase2 <= 1'b0;
                end
            end
            PHASE2: begin
                if (cnt == PHASE2 - 1) begin
                    clk_phase1 <= 1'b0;
                    clk_phase2 <= 1'b0;
                end else begin
                    clk_phase1 <= 1'b0;
                    clk_phase2 <= 1'b1;
                end
            end
        endcase
    end
end

// Delay and advance clock phases
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_phase1_delayed <= 1'b0;
        clk_phase2_advanced <= 1'b0;
    end else begin
        clk_phase1_delayed <= clk_phase1;
        clk_phase2_advanced <= clk_phase2;
    end
end

// Final clock output generation
assign clk_div = clk_phase1_delayed | clk_phase2_advanced;

endmodule