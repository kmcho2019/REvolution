module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam STATE_A = 2'b00;
localparam STATE_B = 2'b01;
localparam STATE_C = 2'b10;
localparam STATE_D = 2'b11;

reg [1:0] state, next_state;
reg [1:0] x_history;  // Shift register for 1-0-1 detection
reg [1:0] y_timer;     // 2-cycle timer for y detection
reg g_latch;           // Permanent g value storage

// Continuous assignments for outputs
assign f = (state == STATE_B);
assign g = (state == STATE_D) || (g_latch && (state == STATE_D || state == STATE_C));

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_history <= 2'b00;
        y_timer <= 2'b00;
        g_latch <= 1'b0;
    end else begin
        state <= next_state;
        
        // Update x history shift register
        x_history <= {x_history[0], x};
        
        // Update y timer when in STATE_D
        if (state == STATE_D) begin
            if (y) begin
                g_latch <= 1'b1;
            end else if (y_timer < 2'b10) begin
                y_timer <= y_timer + 1'b1;
            end else begin
                g_latch <= 1'b0;
            end
        end else begin
            y_timer <= 2'b00;
        end
    end
end

always @(*) begin
    case (state)
        STATE_A: next_state = resetn ? STATE_B : STATE_A;
        
        STATE_B: next_state = STATE_C;
        
        STATE_C: begin
            if (x_history == 2'b01 && x == 1'b1)  // Detected 1-0-1 sequence
                next_state = STATE_D;
            else
                next_state = STATE_C;
        end
        
        STATE_D: begin
            if (g_latch || y_timer >= 2'b10)
                next_state = STATE_C;  // Return to monitoring state
            else
                next_state = STATE_D;
        end
        
        default: next_state = STATE_A;
    endcase
end

endmodule