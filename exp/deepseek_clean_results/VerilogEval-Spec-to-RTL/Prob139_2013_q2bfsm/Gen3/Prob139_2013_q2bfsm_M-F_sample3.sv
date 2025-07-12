module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam STATE_A = 3'd0;  // Reset state
localparam STATE_B = 3'd1;  // f=1 pulse state
localparam STATE_C = 3'd2;  // First x=1 detection
localparam STATE_D = 3'd3;  // x=0 detection
localparam STATE_E = 3'd4;  // Second x=1 detection (sets g=1)
localparam STATE_F = 3'd5;  // y monitoring state
localparam STATE_G = 3'd6;  // Final permanent state

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
        // Default outputs
        f <= 0;
        
        case (state)
            STATE_A: begin
                state <= STATE_B;
            end
            
            STATE_B: begin
                f <= 1;
                state <= STATE_C;
            end
            
            STATE_C: begin
                if (x) state <= STATE_D;
            end
            
            STATE_D: begin
                if (!x) state <= STATE_E;
                else state <= STATE_C;
            end
            
            STATE_E: begin
                if (x) begin
                    g <= 1;
                    state <= STATE_F;
                    timeout_counter <= 0;
                end
                else state <= STATE_C;
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