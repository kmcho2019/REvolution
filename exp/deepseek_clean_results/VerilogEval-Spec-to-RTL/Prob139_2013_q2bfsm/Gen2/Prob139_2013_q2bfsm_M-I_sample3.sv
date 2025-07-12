module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam STATE_A = 3'd0;
localparam STATE_B = 3'd1;
localparam STATE_C = 3'd2;
localparam STATE_D = 3'd3;
localparam STATE_E = 3'd4;
localparam STATE_F = 3'd5;
localparam STATE_G = 3'd6;

reg [2:0] state;
reg [1:0] timeout_counter;

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        timeout_counter <= 0;
    end
    else begin
        case (state)
            STATE_A: begin
                f <= 0;
                g <= 0;
                state <= STATE_B;
            end
            
            STATE_B: begin
                f <= 1;  // Single cycle pulse
                state <= STATE_C;
            end
            
            STATE_C: begin
                f <= 0;
                if (x) state <= STATE_D;
            end
            
            STATE_D: begin
                if (!x) state <= STATE_E;
                else state <= STATE_D;
            end
            
            STATE_E: begin
                if (x) begin
                    g <= 1;
                    state <= STATE_F;
                    timeout_counter <= 0;
                end
                else begin
                    state <= STATE_C;
                end
            end
            
            STATE_F: begin
                if (y) begin
                    state <= STATE_G;
                end
                else if (timeout_counter == 2'd1) begin
                    g <= 0;
                    state <= STATE_G;
                end
                else begin
                    timeout_counter <= timeout_counter + 1;
                end
            end
            
            STATE_G: begin
                // Permanent state - maintain current g value
            end
        endcase
    end
end

endmodule