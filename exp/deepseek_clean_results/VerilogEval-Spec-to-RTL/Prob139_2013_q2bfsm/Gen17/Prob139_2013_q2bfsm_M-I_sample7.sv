module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam STATE_A     = 3'b000;  // Initial/reset state
localparam STATE_B     = 3'b001;  // Pulse f state
localparam STATE_C     = 3'b010;  // Monitor for 101 pattern
localparam STATE_D1    = 3'b011;  // First y monitoring cycle
localparam STATE_D2    = 3'b100;  // Second y monitoring cycle
localparam STATE_FINAL = 3'b101;  // Final state

reg [2:0] state, next_state;
reg [2:0] x_shift;  // 3-bit shift register for pattern detection
reg g_permanent;     // Permanent g value

// State transition logic
always @(*) begin
    next_state = state;
    case (state)
        STATE_A: next_state = resetn ? STATE_B : STATE_A;
        STATE_B: next_state = STATE_C;
        STATE_C: begin
            if (x_shift == 3'b101)
                next_state = STATE_D1;
        end
        STATE_D1: begin
            if (y)
                next_state = STATE_FINAL;
            else
                next_state = STATE_D2;
        end
        STATE_D2: next_state = STATE_FINAL;
        STATE_FINAL: next_state = STATE_FINAL;
    endcase
end

// Output and sequential logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_shift <= 3'b0;
        f <= 1'b0;
        g <= 1'b0;
        g_permanent <= 1'b0;
    end
    else begin
        state <= next_state;
        x_shift <= {x_shift[1:0], x};  // Shift in new x value
        
        // Output f logic
        f <= (next_state == STATE_B);
        
        // Output g logic
        if (next_state == STATE_D1 || next_state == STATE_D2) begin
            g <= 1'b1;
        end
        else if (next_state == STATE_FINAL) begin
            if (state == STATE_D1 && y) begin
                g <= 1'b1;
                g_permanent <= 1'b1;
            end
            else if (state == STATE_D2 && y) begin
                g <= 1'b1;
                g_permanent <= 1'b1;
            end
            else if (state == STATE_D2 && !y) begin
                g <= 1'b0;
                g_permanent <= 1'b0;
            end
            else if (g_permanent) begin
                g <= 1'b1;
            end
            else begin
                g <= 1'b0;
            end
        end
    end
end

endmodule