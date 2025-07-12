module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Simplified state encoding
localparam STATE_A = 2'd0;  // Reset state
localparam STATE_B = 2'd1;  // f=1 pulse state
localparam STATE_C = 2'd2;  // x sequence detection
localparam STATE_D = 2'd3;  // g=1 with y monitoring
localparam STATE_E = 2'd4;  // Final state (g permanent)

reg [2:0] state;

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
    end
    else begin
        case (state)
            STATE_A: begin
                f <= 0;
                g <= 0;
                state <= STATE_B;
            end
            
            STATE_B: begin
                f <= 1;
                state <= STATE_C;
            end
            
            STATE_C: begin
                f <= 0;
                if (x) state <= STATE_C_DETECT0;  // Wait for x=1
            end
            
            STATE_C_DETECT0: begin
                if (!x) state <= STATE_C_DETECT1;  // After x=1, wait for x=0
                else state <= STATE_C_DETECT0;
            end
            
            STATE_C_DETECT1: begin
                if (x) begin
                    g <= 1;
                    state <= STATE_D;
                end
                else state <= STATE_C;
            end
            
            STATE_D: begin
                if (y) begin
                    state <= STATE_E;
                end
                else if (state == STATE_D_TIMEOUT) begin
                    g <= 0;
                    state <= STATE_E;
                end
                else begin
                    state <= STATE_D_TIMEOUT;
                end
            end
            
            STATE_E: begin
                // Permanent state - maintain g value
            end
        endcase
    end
end

endmodule